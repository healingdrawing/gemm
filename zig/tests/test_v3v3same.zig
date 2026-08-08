const std = @import("std");
const dp = @import("../utils/debug.zig");
const data_v3v3same = @import("data_v3v3same.zig");
const floatUtils = @import("float.zig");
const gemm = @import("../gemm.zig").GEMM;
const report = @import("report.zig");

pub fn test_v3v3same(epsilon: f32) !report.MethodResult {
    _ = epsilon; // not used for exact bool, keep signature identical
    const allocator = std.heap.page_allocator;
    var failed: usize = 0;

    dp.devlog(.{"Running v3v3same tests..."});

    for (data_v3v3same.cases) |case| {
        // Call Zig method (returns bool)
        const zig_bool = gemm.v3v3same(case.a, case.b);
        const zig_result = try floatUtils.to_array(allocator, @as(f32, if (zig_bool) 1 else 0));
        defer allocator.free(zig_result);

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{ case.a, case.b });
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminalcall.ts v3v3same {s}", .{data_str});
        defer allocator.free(cmd);

        const result = try std.process.run(allocator, io, .{
            .argv = &.{ "sh", "-c", cmd },
            .cwd = .inherit,
        });

        defer allocator.free(result.stdout);
        defer allocator.free(result.stderr);

        // Parse TS result (expects 1/0)
        const ts_result = try floatUtils.parse_float_result(allocator, result.stdout);
        defer allocator.free(ts_result);

        // expected from data file
        const expected: []const f32 = &case.outarr;

        const ok_zig_ts = try floatUtils.arrays_equal(zig_result, ts_result, 0);
        const ok_zig_exp = try floatUtils.arrays_equal(zig_result, expected, 0);
        const ok_ts_exp = try floatUtils.arrays_equal(ts_result, expected, 0);

        if (ok_zig_ts and ok_zig_exp and ok_ts_exp) {
            std.debug.print("✓ v3v3same({any}, {any}) = {any}\n", .{ case.a, case.b, zig_result });
        } else {
            failed += 1;
            dp.errlog(.{
                "✗ v3v3same",
                "a",
                case.a,
                "b",
                case.b,
                "zig_result",
                zig_result,
                "ts_result",
                ts_result,
                "expected",
                expected,
                "data_str",
                data_str,
            });
        }
    }
    return .{
        .name = "v3v3same",
        .total = data_v3v3same.cases.len,
        .failed = failed,
    };
}
