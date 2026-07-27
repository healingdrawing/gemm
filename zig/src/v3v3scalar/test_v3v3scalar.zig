const std = @import("std");
const v3v3scalar = @import("v3v3scalar.zig").v3v3scalar;

test "v3v3scalar matches TS terminal bridge" {
    const a: @Vector(3, f32) = .{ 1, 2, 3 };
    const b: @Vector(3, f32) = .{ 4, 5, 6 };
    const zig_result = v3v3scalar(a, b);
    std.debug.print("zig: {any}\n", .{zig_result});

    const allocator = std.heap.page_allocator;
    const io = std.testing.io;

    const zig_dir = std.Io.Dir.cwd();

    const ts_dir = try zig_dir.openDir(io, "../../../", .{});
    defer ts_dir.close(io);

    const result = try std.process.run(allocator, io, .{
        .argv = &.{ "bun", "ts/terminal.test.ts", "v3v3scalar", "1", "2", "3", "4", "5", "6" },
        .cwd = .{ .dir = ts_dir },
    });
    defer allocator.free(result.stdout);
    defer allocator.free(result.stderr);

    std.debug.print("bun: {s}\n", .{result.stdout});
    std.debug.print("err: {s}\n", .{result.stderr});
}
