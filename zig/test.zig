const std = @import("std");
const gemm = @import("gemm.zig").GEMM;
const floatUtils = @import("tests/float.zig");
const data = @import("tests/data_v3v3scalar.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    std.debug.print("Running v3v3scalar tests...\n", .{});

    for (data.cases) |case| {
        // Call Zig method
        const zig_result = try floatUtils.to_array(allocator, gemm.v3v3scalar(case.a, case.b));

        // Call TS bridge
        const data_str = try floatUtils.vectors_to_string(allocator, .{ case.a, case.b });
        defer allocator.free(data_str);

        var t_io = std.Io.Threaded.init(allocator, .{});
        defer t_io.deinit();
        const io = t_io.io();

        const cmd = try std.fmt.allocPrint(allocator, "/home/user/.bun/bin/bun ../ts/terminal.test.ts v3v3scalar {s}", .{data_str});
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
        const epsilon = 1e-5;
        if (try floatUtils.arrays_equal(zig_result, ts_result, epsilon)) {
            std.debug.print("✓ v3v3scalar({any}, {any}) = {any}\n", .{ case.a, case.b, zig_result });
        } else {
            std.debug.print("✗ v3v3scalar({any}, {any}): Zig={any}, TS={any}\n", .{ case.a, case.b, zig_result, ts_result });
        }
    }
}
