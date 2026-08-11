const std = @import("std");
const floatUtils = @import("float.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const a: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
    const b: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
    const c: [3]f32 = .{ 7.0, 8.0, 9.0 };
    const d: [1]f32 = .{10.0};

    const result = try floatUtils.vectors_to_string(allocator, .{ a, b, c, d });
    defer allocator.free(result);

    std.debug.print("Result: {s}\n", .{result});
}
