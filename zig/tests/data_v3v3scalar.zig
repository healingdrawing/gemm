const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    .{
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, 6 },
        .outarr = .{32}, // dot product: 1*4 + 2*5 + 3*6 = 32
    },
    .{
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, std.math.nan(f32) },
        .outarr = .{std.math.nan(f32)}, // dot product: 1*4 + 2*5 + 3*6 = 32
    },
    // Add more test cases
};
