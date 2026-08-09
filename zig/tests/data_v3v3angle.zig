// tests/data_v3v3angle.zig
const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    .{ // identical → 0
        .a = .{ 1, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{0},
    },
    .{ // opposite → π
        .a = .{ 1, 0, 0 },
        .b = .{ -1, 0, 0 },
        .outarr = .{std.math.pi},
    },
    .{ // perpendicular → π/2
        .a = .{ 1, 0, 0 },
        .b = .{ 0, 1, 0 },
        .outarr = .{std.math.pi / 2.0},
    },
    .{ // classic 3-4-5 perpendicular
        .a = .{ 3, 4, 0 },
        .b = .{ 4, -3, 0 },
        .outarr = .{std.math.pi / 2.0},
    },
    .{ // 45° (π/4)
        .a = .{ 1, 1, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{std.math.pi / 4.0},
    },
    .{ // scaled same direction → 0
        .a = .{ 2, 4, 6 },
        .b = .{ 1, 2, 3 },
        .outarr = .{0},
    },
    .{ // scaled opposite → π
        .a = .{ 2, 4, 6 },
        .b = .{ -1, -2, -3 },
        .outarr = .{std.math.pi},
    },
    .{ // NaN propagates
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, std.math.nan(f32) },
        .outarr = .{std.math.nan(f32)},
    },
    .{ // +inf → NaN
        .a = .{ 1, 2, 3 },
        .b = .{ std.math.inf(f32), 5, 6 },
        .outarr = .{std.math.nan(f32)},
    },
    .{ // zero-ish (sanitized assumption)
        .a = .{ 1e-20, 0, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{0},
    },
    .{ // negative components (same direction)
        .a = .{ -1, -2, -3 },
        .b = .{ -4, -5, -6 },
        .outarr = .{0.2257261285523355}, // acos(0.9746318461970762)
    },
    .{ // almost parallel → ~0
        .a = .{ 1, 0, 0 },
        .b = .{ 0.999999, 0.000001, 0 },
        .outarr = .{0},
    },
};
