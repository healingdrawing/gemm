const std = @import("std");
const dp = @import("../utils/debug.zig");
const data_v3one = @import("data_v3one.zig");
const floatUtils = @import("float.zig");
const gemm = @import("../gemm.zig").GEMM;

pub fn test_v3one(epsilon: f32) !void {
    const allocator = std.heap.page_allocator;

    dp.devlog(.{"Running v3one tests..."});

    for (data_v3one.cases) |case| {
        // Call Zig method
        const zig_result = try floatUtils.to_array(allocator, gemm.v3one(case.v));

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{case.v});
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminal.test.ts v3one {s}", .{data_str});
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
            std.debug.print("✓ v3one({any}): Zig={any}, TS={any}\n", .{ case.v, zig_result, ts_result });
        } else {
            dp.errlog(.{ "✗ v3one", "v", case.v, "zig_result", zig_result, "ts_result", ts_result, "data_str", data_str });
        }
    }
}
