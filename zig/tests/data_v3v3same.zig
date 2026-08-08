const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32, // 1.0 = true, 0.0 = false
};

pub const cases = [_]TestCase{
    .{ // identical
        .a = .{ 1, 2, 3 },
        .b = .{ 1, 2, 3 },
        .outarr = .{1},
    },
    .{ // different
        .a = .{ 1, 2, 3 },
        .b = .{ 1, 2, 4 },
        .outarr = .{0},
    },
    .{ // zero == zero
        .a = .{ 0, 0, 0 },
        .b = .{ 0, 0, 0 },
        .outarr = .{1},
    },
    .{ // +0 vs -0  (IEEE: +0.0 == -0.0 is true)
        .a = .{ 0, 0, 0 },
        .b = .{ -0.0, -0.0, -0.0 },
        .outarr = .{1},
    },
    .{ // negative identical
        .a = .{ -1.5, -2.5, -3.5 },
        .b = .{ -1.5, -2.5, -3.5 },
        .outarr = .{1},
    },
    .{ // first component differs
        .a = .{ 1, 0, 0 },
        .b = .{ 2, 0, 0 },
        .outarr = .{0},
    },
    .{ // NaN != NaN
        .a = .{ std.math.nan(f32), 2, 3 },
        .b = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{0},
    },
    .{ // Inf == Inf
        .a = .{ std.math.inf(f32), 0, 0 },
        .b = .{ std.math.inf(f32), 0, 0 },
        .outarr = .{1},
    },
    .{ // +Inf != -Inf
        .a = .{ std.math.inf(f32), 0, 0 },
        .b = .{ -std.math.inf(f32), 0, 0 },
        .outarr = .{0},
    },
    .{ // mixed Inf/NaN
        .a = .{ std.math.inf(f32), std.math.nan(f32), 0 },
        .b = .{ std.math.inf(f32), std.math.nan(f32), 0 },
        .outarr = .{0}, // because of NaN
    },
    .{ // very close but not equal
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 1e-7, 2.0, 3.0 },
        .outarr = .{0},
    },
};
