// tests/data_v3normal.zig
const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    .{ // i × j → k
        .a = .{ 1, 0, 0 },
        .b = .{ 0, 1, 0 },
        .outarr = .{ 0, 0, 1 },
    },
    .{ // j × k → i
        .a = .{ 0, 1, 0 },
        .b = .{ 0, 0, 1 },
        .outarr = .{ 1, 0, 0 },
    },
    .{ // k × i → j
        .a = .{ 0, 0, 1 },
        .b = .{ 1, 0, 0 },
        .outarr = .{ 0, 1, 0 },
    },
    .{ // opposite order → -k
        .a = .{ 0, 1, 0 },
        .b = .{ 1, 0, 0 },
        .outarr = .{ 0, 0, -1 },
    },
    .{ // classic non-unit
        .a = .{ 3, 0, 0 },
        .b = .{ 0, 4, 0 },
        .outarr = .{ 0, 0, 1 },
    },
    .{ // scaled + mixed signs
        .a = .{ 1, 2, 3 },
        .b = .{ 4, 5, 6 },
        .outarr = .{ -0.4082482904638631, 0.8164965809277261, -0.4082482904638631 }, // normalized (a×b)
    },
    .{ // parallel → zero vector (mag==0 path)
        .a = .{ 1, 2, 3 },
        .b = .{ 2, 4, 6 },
        .outarr = .{ 0, 0, 0 },
    },
    .{ // anti-parallel
        .a = .{ 1, 0, 0 },
        .b = .{ -2, 0, 0 },
        .outarr = .{ 0, 0, 0 },
    },
    .{ // negative components
        .a = .{ -1, -2, 0 },
        .b = .{ 0, -3, -4 },
        .outarr = .{ 0.8479983, -0.42399916, 0.31799936 },
    },
    .{ // NaN in one component of b
        .a = .{ 1, 2, 3 },
        .b = .{ 4, std.math.nan(f32), 6 },
        .outarr = .{ std.math.nan(f32), 6, std.math.nan(f32) },
    },
    .{ // +inf → raw cross (mag becomes NaN → else branch)
        .a = .{ std.math.inf(f32), 0, 0 },
        .b = .{ 0, 1, 0 },
        .outarr = .{ 0, std.math.nan(f32), std.math.inf(f32) },
    },
};
