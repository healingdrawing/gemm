// tests/data_p3_d3d3.zig
const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    d3n: @Vector(3, f32),
    outarr: [4]f32,
};

pub const cases = [_]TestCase{
    // unit normal along +Z, plane through origin → [0,0,1,0]
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 0, 0, 1 },
        .outarr = .{ 0, 0, 1, 0 },
    },
    // unit normal along +X, plane through origin → [1,0,0,0]
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 1, 0, 0 },
        .outarr = .{ 1, 0, 0, 0 },
    },
    // unit normal along +Y, plane z=0 through (0,0,0)
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 0, 1, 0 },
        .outarr = .{ 0, 1, 0, 0 },
    },
    // plane z = 5 (point on plane (0,0,5), normal tip (0,0,6))
    .{
        .d3 = .{ 0, 0, 5 },
        .d3n = .{ 0, 0, 6 },
        .outarr = .{ 0, 0, 1, -5 },
    },
    // non-unit normal (scaled), should normalize
    .{
        .d3 = .{ 1, 2, 3 },
        .d3n = .{ 1, 2, 5 }, // delta = (0,0,2) → normal (0,0,1), d = -3
        .outarr = .{ 0, 0, 1, -3 },
    },
    // arbitrary
    .{
        .d3 = .{ 1, 0, 0 },
        .d3n = .{ 2, 0, 0 }, // normal (1,0,0), d = -1
        .outarr = .{ 1, 0, 0, -1 },
    },
    // opposite direction
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 0, 0, -2 },
        .outarr = .{ 0, 0, -1, 0 },
    },
    // diagonal normalized
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 1, 1, 1 },
        .outarr = .{ 1.0 / @sqrt(3.0), 1.0 / @sqrt(3.0), 1.0 / @sqrt(3.0), 0 },
    },
    // zero-length normal → NaN (TS division by zero)
    .{
        .d3 = .{ 1, 2, 3 },
        .d3n = .{ 1, 2, 3 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in d3n
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ 0, std.math.nan(f32), 1 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // +inf component
    .{
        .d3 = .{ 0, 0, 0 },
        .d3n = .{ std.math.inf(f32), 0, 0 },
        .outarr = .{ std.math.nan(f32), 0, 0, std.math.nan(f32) },
    },
};
