const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    .{
        .v = .{ 1, 2, 3 },
        .outarr = .{14}, // 1*1 + 2*2 + 3*3 = 14
    },
    .{
        .v = .{ 3, 4, 0 },
        .outarr = .{25}, // 9 + 16 + 0 = 25
    },
    .{
        .v = .{ 0, 0, 0 },
        .outarr = .{0},
    },
    .{
        .v = .{ -1, -2, -3 },
        .outarr = .{14}, // signs cancel in squares
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
        .v = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{std.math.nan(f32)}, // NaN propagates
    },
    .{
        .v = .{ 1, std.math.inf(f32), 3 },
        .outarr = .{std.math.inf(f32)}, // +inf propagates
    },
    .{
        .v = .{ 1, -std.math.inf(f32), 3 },
        .outarr = .{std.math.inf(f32)}, // (-inf)^2 = +inf
    },
    .{
        .v = .{ std.math.inf(f32), -std.math.inf(f32), 0 },
        .outarr = .{std.math.inf(f32)}, // inf + inf = inf
    },
};
