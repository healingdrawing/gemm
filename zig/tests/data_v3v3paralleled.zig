// tests/data_v3v3paralleled.zig
const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32, // 1.0 = true, 0.0 = false
};

pub const cases = [_]TestCase{
    .{ // identical unit → true
        .a = .{ 1, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{ // scaled same direction → true
        .a = .{ 2, 4, 6 },
        .b = .{ 1, 2, 3 },
        .outarr = .{1},
    },
    .{ // opposite unit → true
        .a = .{ 1, 0, 0 },
        .b = .{ -1, 0, 0 },
        .outarr = .{1},
    },
    .{ // scaled opposite → true
        .a = .{ 2, 4, 6 },
        .b = .{ -1, -2, -3 },
        .outarr = .{1},
    },
    .{ // perpendicular → false
        .a = .{ 1, 0, 0 },
        .b = .{ 0, 1, 0 },
        .outarr = .{0},
    },
    .{ // almost parallel same side → true
        .a = .{ 1, 0, 0 },
        .b = .{ 0.999999, 0.000001, 0 },
        .outarr = .{1},
    },
    .{ // almost parallel opposite → true
        .a = .{ 1, 0, 0 },
        .b = .{ -0.999999, -0.000001, 0 },
        .outarr = .{1},
    },
    .{ // clearly not parallel → false
        .a = .{ 1, 1, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{0},
    },
    .{ // negative same direction → true
        .a = .{ -1, -2, -3 },
        .b = .{ -2, -4, -6 },
        .outarr = .{1},
    },
    .{ // zero-ish same → true
        .a = .{ 1e-20, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{ // NaN → false
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, std.math.nan(f32) },
        .outarr = .{0},
    },
};
