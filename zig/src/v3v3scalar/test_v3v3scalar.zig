const std = @import("std");
const v3v3scalar = @import("v3v3scalar.zig").v3v3scalar;
const floatUtils = @import("float.zig"); // todo can not import from outside module path , but in same time can see import is correct in editor. so file float.zig copied on same level. bullshit.

//warning to run from gemm folder level , remove hardcoded ../../../ from ts/terminal ...ugly ugly shit, maybe later polish

//warning zig run test_v3v3scalar.zig

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const a: @Vector(3, f32) = .{ 1, 2, 3 };
    const b: @Vector(3, f32) = .{ 4, 5, 6 };
    const raw_result = v3v3scalar(a, b);
    const zig_result = try floatUtils.to_array(allocator, raw_result);
    defer allocator.free(zig_result);
    var t_io = std.Io.Threaded.init(allocator, .{});
    defer t_io.deinit();
    const io = t_io.io();

    const result = try std.process.run(allocator, io, .{
        .argv = &.{ "sh", "-c", "/home/user/.bun/bin/bun ../../../ts/terminal.test.ts v3v3scalar 1 2 3 4 5 6" },
        .cwd = .inherit,
    });

    defer allocator.free(result.stdout);
    defer allocator.free(result.stderr);

    std.debug.print("zig: {any}\n", .{zig_result});
    std.debug.print("stderr: {s}\n", .{result.stderr});
    std.debug.print("stdout: {s}\n", .{result.stdout});
    std.debug.print("term: {any}\n", .{result.term});

    const ts_values = try floatUtils.parse_float_result(allocator, result.stdout);
    defer allocator.free(ts_values);

    const epsilon = 1e-5;
    const matches = try floatUtils.arrays_equal(zig_result, ts_values, epsilon);
    std.debug.print("matches: {}\n", .{matches});
}
