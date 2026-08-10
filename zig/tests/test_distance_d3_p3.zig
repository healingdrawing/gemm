const std = @import("std");
const dp = @import("../utils/debug.zig");
const data_distance_d3_p3 = @import("data_distance_d3_p3.zig");
const floatUtils = @import("float.zig");
const gemm = @import("../gemm.zig").GEMM;
const report = @import("report.zig");

pub fn test_distance_d3_p3(epsilon: f32) !report.MethodResult {
    const allocator = std.heap.page_allocator;
    var failed: usize = 0;

    dp.devlog(.{"Running distance_d3_p3 tests..."});

    for (data_distance_d3_p3.cases) |case| {
        // Call Zig method
        const zig_result = try floatUtils.to_array(allocator, gemm.distance_d3_p3(case.d3, case.p3));
        defer allocator.free(zig_result);

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{ case.d3, case.p3 });
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminalcall.ts distance_d3_p3 {s}", .{data_str});
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

        // expected from data file (zero-cost)
        const expected: []const f32 = &case.outarr;

        const ok_zig_ts = try floatUtils.arrays_equal(zig_result, ts_result, epsilon);
        const ok_zig_exp = try floatUtils.arrays_equal(zig_result, expected, epsilon);
        const ok_ts_exp = try floatUtils.arrays_equal(ts_result, expected, epsilon);

        if (ok_zig_ts and ok_zig_exp and ok_ts_exp) {
            std.debug.print("✓ distance_d3_p3({any}, {any}) = {any}\n", .{ case.d3, case.p3, zig_result });
        } else {
            failed += 1;
            dp.errlog(.{
                "✗ distance_d3_p3",
                "d3",
                case.d3,
                "p3",
                case.p3,
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
        .name = "distance_d3_p3",
        .total = data_distance_d3_p3.cases.len,
        .failed = failed,
    };
}
