const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    v3: @Vector(3, f32),
    p3: @Vector(4, f32),
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    // line from origin along +z, plane z=5 → (0,0,5)
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 0, 0, 1 },
        .p3 = .{ 0, 0, 1, -5 },
        .outarr = .{ 0, 0, 5 },
    },
    // already on plane → same point
    .{
        .d3 = .{ 1, 2, 0 },
        .v3 = .{ 0, 0, 1 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{ 1, 2, 0 },
    },
    // classic: from (0,0,0) dir (1,1,1), plane x+y+z=3 → (1,1,1)
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 1, 1 },
        .p3 = .{ 1, 1, 1, -3 },
        .outarr = .{ 1, 1, 1 },
    },
    // non-unit normal, plane 2x=4 → x=2
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 0, 0 },
        .p3 = .{ 2, 0, 0, -4 },
        .outarr = .{ 2, 0, 0 },
    },
    // negative direction
    .{
        .d3 = .{ 10, 0, 0 },
        .v3 = .{ -1, 0, 0 },
        .p3 = .{ 1, 0, 0, -3 },
        .outarr = .{ 3, 0, 0 },
    },
    // parallel (denom=0) → Inf
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 0, 0 },
        .p3 = .{ 0, 1, 0, -5 },
        .outarr = .{ std.math.inf(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // parallel + already on plane (0/0) → NaN
    .{
        .d3 = .{ 0, 5, 0 },
        .v3 = .{ 1, 0, 0 },
        .p3 = .{ 0, 1, 0, -5 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in d3 propagates
    .{
        .d3 = .{ std.math.nan(f32), 0, 0 },
        .v3 = .{ 0, 0, 1 },
        .p3 = .{ 0, 0, 1, -1 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // Inf in v3
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ std.math.inf(f32), 0, 0 },
        .p3 = .{ 1, 0, 0, -5 },
        .outarr = .{ std.math.nan(f32), 0, 0 },
    },
    // diagonal hit
    .{
        .d3 = .{ 1, 1, 1 },
        .v3 = .{ 1, 2, 3 },
        .p3 = .{ 0, 0, 1, -10 },
        .outarr = .{ 4, 7, 10 },
    },
};
