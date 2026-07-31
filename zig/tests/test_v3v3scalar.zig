const std = @import("std");
const dp = @import("../utils/debug.zig");
const data_v3v3scalar = @import("data_v3v3scalar.zig");
const floatUtils = @import("float.zig");
const gemm = @import("../gemm.zig").GEMM;

pub fn test_v3v3scalar(epsilon: f32) !void {
    const allocator = std.heap.page_allocator;

    dp.devlog(.{"Running v3v3scalar tests..."});

    for (data_v3v3scalar.cases) |case| {
        // Call Zig method
        const zig_result = try floatUtils.to_array(allocator, gemm.v3v3scalar(case.a, case.b));
        defer allocator.free(zig_result);

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{ case.a, case.b });
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminalcall.ts v3v3scalar {s}", .{data_str});
        defer allocator.free(cmd);

        const result = try std.process.run(allocator, io, .{
            .argv = &.{ "sh", "-c", cmd },
            .cwd = .inherit,
        });

        defer allocator.free(result.stdout);
        defer allocator.free(result.stderr);

        // Parse TS result
        const ts_result = try floatUtils.parse_float_result(allocator, result.stdout);

        // Compare
        if (try floatUtils.arrays_equal(zig_result, ts_result, epsilon)) {
            std.debug.print("✓ v3v3scalar({any}, {any}) = {any}\n", .{ case.a, case.b, zig_result });
        } else {
            dp.errlog(.{ "✗ v3v3scalar", "a", case.a, "b", case.b, "zig_result", zig_result, "ts_result", ts_result, "data_str", data_str });
        }
    }
}
