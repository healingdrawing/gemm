// tests/test_v3v3cos.zig
const std = @import("std");
const dp = @import("../utils/debug.zig");
const data_v3v3cos = @import("data_v3v3cos.zig");
const floatUtils = @import("float.zig");
const gemm = @import("../gemm.zig").GEMM;
const report = @import("report.zig");

pub fn test_v3v3cos(epsilon: f32) !report.MethodResult {
    const allocator = std.heap.page_allocator;
    var failed: usize = 0;

    dp.devlog(.{"Running v3v3cos tests..."});

    for (data_v3v3cos.cases) |case| {
        // Call Zig method
        const zig_result = try floatUtils.to_array(allocator, gemm.v3v3cos(case.a, case.b));
        defer allocator.free(zig_result);

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{ case.a, case.b });
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminalcall.ts v3v3cos {s}", .{data_str});
        defer allocator.free(cmd);

        const result = try std.process.run(allocator, io, .{
            .argv = &.{ "sh", "-c", cmd },
            .cwd = .inherit,
        });

        defer allocator.free(result.stdout);
        defer allocator.free(result.stderr);

        // Parse TS result
        const ts_result = try floatUtils.parse_float_result(allocator, result.stdout);
        defer allocator.free(ts_result);

        // expected from data file
        const expected: []const f32 = &case.outarr;

        const ok_zig_ts = try floatUtils.arrays_equal(zig_result, ts_result, epsilon);
        const ok_zig_exp = try floatUtils.arrays_equal(zig_result, expected, epsilon);
        const ok_ts_exp = try floatUtils.arrays_equal(ts_result, expected, epsilon);

        if (ok_zig_ts and ok_zig_exp and ok_ts_exp) {
            std.debug.print("✓ v3v3cos({any}, {any}) = {any}\n", .{ case.a, case.b, zig_result });
        } else {
            failed += 1;
            dp.errlog(.{
                "✗ v3v3cos",
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
        .name = "v3v3cos",
        .total = data_v3v3cos.cases.len,
        .failed = failed,
    };
}
