const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    .{
        .v = .{ 1, 2, 3 },
        .outarr = .{3.7416575}, // sqrt(1+4+9) = sqrt(14) ≈ 3.7416575
    },
    .{
        .v = .{ 3, 4, 0 },
        .outarr = .{5}, // sqrt(9+16+0) = 5
    },
    .{
        .v = .{ 0, 0, 0 },
        .outarr = .{0},
    },
    .{
        .v = .{ -1, -2, -3 },
        .outarr = .{3.7416575}, // signs cancel in squares
    },
    .{
        .v = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{
        .v = .{ 0, 1, 0 },
        .outarr = .{1},
    },
    .{
        .v = .{ 0, 0, 1 },
        .outarr = .{1},
    },
    .{
        .v = .{ 5, 12, 0 },
        .outarr = .{13}, // classic 5-12-13
    },
    .{
        .v = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{std.math.nan(f32)}, // NaN propagates
    },
    .{
        .v = .{ 1, std.math.inf(f32), 3 },
        .outarr = .{std.math.inf(f32)}, // +inf propagates
    },
    .{
        .v = .{ 1, -std.math.inf(f32), 3 },
        .outarr = .{std.math.inf(f32)}, // (-inf)^2 = +inf → sqrt(+inf)
    },
    .{
        .v = .{ std.math.inf(f32), -std.math.inf(f32), 0 },
        .outarr = .{std.math.inf(f32)},
    },
};
