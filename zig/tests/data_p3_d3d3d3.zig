const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    d3a: @Vector(3, f32),
    d3b: @Vector(3, f32),
    outarr: [4]f32,
};

pub const cases = [_]TestCase{
    // XY plane, origin, normal +Z
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 1, 0, 0 },
        .d3b = .{ 0, 1, 0 },
        .outarr = .{ 0, 0, 1, 0 },
    },
    // XY plane, origin, opposite order → -Z
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 0, 1, 0 },
        .d3b = .{ 1, 0, 0 },
        .outarr = .{ 0, 0, -1, 0 },
    },
    // plane z = 5 (points at z=5)
    .{
        .d3 = .{ 0, 0, 5 },
        .d3a = .{ 1, 0, 5 },
        .d3b = .{ 0, 1, 5 },
        .outarr = .{ 0, 0, 1, -5 },
    },
    // YZ plane, normal +X
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 0, 1, 0 },
        .d3b = .{ 0, 0, 1 },
        .outarr = .{ 1, 0, 0, 0 },
    },
    // non-origin, non-unit edges
    .{
        .d3 = .{ 1, 2, 3 },
        .d3a = .{ 4, 2, 3 },
        .d3b = .{ 1, 6, 3 },
        .outarr = .{ 0, 0, 1, -3 },
    },
    // classic triangle
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 2, 0, 0 },
        .d3b = .{ 0, 3, 0 },
        .outarr = .{ 0, 0, 1, 0 },
    },
    // collinear points → division by zero → NaN components
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 1, 0, 0 },
        .d3b = .{ 2, 0, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in one point
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ 1, std.math.nan(f32), 0 },
        .d3b = .{ 0, 1, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // Inf component
    .{
        .d3 = .{ 0, 0, 0 },
        .d3a = .{ std.math.inf(f32), 0, 0 },
        .d3b = .{ 0, 1, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
};
