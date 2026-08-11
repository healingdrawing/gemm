// tests/data_v3v3cos.zig
const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    .{ // identical unit → 1
        .a = .{ 1, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{ // opposite → -1
        .a = .{ 1, 0, 0 },
        .b = .{ -1, 0, 0 },
        .outarr = .{-1},
    },
    .{ // perpendicular → 0
        .a = .{ 1, 0, 0 },
        .b = .{ 0, 1, 0 },
        .outarr = .{0},
    },
    .{ // classic 3-4-5 style
        .a = .{ 3, 4, 0 },
        .b = .{ 4, -3, 0 },
        .outarr = .{0}, // perpendicular
    },
    .{ // known cos
        .a = .{ 1, 1, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{0.7071067811865475}, // 1/√2
    },
    .{ // scaled same direction → 1
        .a = .{ 2, 4, 6 },
        .b = .{ 1, 2, 3 },
        .outarr = .{1},
    },
    .{ // scaled opposite → -1
        .a = .{ 2, 4, 6 },
        .b = .{ -1, -2, -3 },
        .outarr = .{-1},
    },
    .{ // NaN propagates
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, std.math.nan(f32) },
        .outarr = .{std.math.nan(f32)},
    },
    .{ // +inf propagates
        .a = .{ 1, 2, 3 },
        .b = .{ std.math.inf(f32), 5, 6 },
        .outarr = .{std.math.nan(f32)}, // inf / inf → NaN after cut? actually produces NaN in practice
    },
    .{ // zero-ish but sanitized assumption; still cover
        .a = .{ 1e-20, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{ // negative components
        .a = .{ -1, -2, -3 },
        .b = .{ -4, -5, -6 },
        .outarr = .{0.9746318461970762}, // positive cos
    },
    .{ // almost parallel (clamped by sin_cos_cut if needed)
        .a = .{ 1, 0, 0 },
        .b = .{ 0.999999, 0.000001, 0 },
        .outarr = .{0.9999999999995}, // ~1, cut if >1
    },
};
