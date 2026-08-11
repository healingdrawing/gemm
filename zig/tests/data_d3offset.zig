const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    v3: @Vector(3, f32),
    t: f32,
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    // unit vector +t
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 0, 0 },
        .t = 5.0,
        .outarr = .{ 5, 0, 0 },
    },
    // unit vector -t
    .{
        .d3 = .{ 1, 2, 3 },
        .v3 = .{ 0, 1, 0 },
        .t = -2.0,
        .outarr = .{ 1, 0, 3 },
    },
    // non-unit vector
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 3, 4, 0 },
        .t = 10.0,
        .outarr = .{ 6, 8, 0 },
    },
    // t == 0 → unchanged
    .{
        .d3 = .{ 7, 8, 9 },
        .v3 = .{ 1, 1, 1 },
        .t = 0.0,
        .outarr = .{ 7, 8, 9 },
    },
    // zero vector → unchanged
    .{
        .d3 = .{ 1, 2, 3 },
        .v3 = .{ 0, 0, 0 },
        .t = 5.0,
        .outarr = .{ 1, 2, 3 },
    },
    // negative direction, non-unit
    .{
        .d3 = .{ 10, 0, 0 },
        .v3 = .{ -3, -4, 0 },
        .t = 5.0,
        .outarr = .{ 7, -4, 0 },
    },
    // 3D diagonal
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 1, 1 },
        .t = @sqrt(3.0),
        .outarr = .{ 1, 1, 1 },
    },
    // NaN in v3 → propagates
    .{
        .d3 = .{ 1, 2, 3 },
        .v3 = .{ std.math.nan(f32), 0, 0 },
        .t = 1.0,
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // Inf in v3
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ std.math.inf(f32), 0, 0 },
        .t = 1.0,
        .outarr = .{ std.math.nan(f32), 0, 0 },
    },
    // t = Inf
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 0, 0 },
        .t = std.math.inf(f32),
        .outarr = .{ std.math.inf(f32), std.math.nan(f32), std.math.nan(f32) },
    },
};
