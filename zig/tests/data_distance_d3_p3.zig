const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    p3: @Vector(4, f32),
    outarr: [1]f32,
};

pub const cases = [_]TestCase{
    // unit plane z=0, point (0,0,5) → dist 5
    .{
        .d3 = .{ 0, 0, 5 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{5},
    },
    // unit plane z=0, point on plane → 0
    .{
        .d3 = .{ 1, 2, 0 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{0},
    },
    // plane x=0, point (3,0,0) → 3
    .{
        .d3 = .{ 3, 0, 0 },
        .p3 = .{ 1, 0, 0, 0 },
        .outarr = .{3},
    },
    // plane x+y+z=0 (normal not unit), point (1,1,1)
    // |1+1+1| / sqrt(3) = 3/sqrt(3) = sqrt(3) ≈ 1.7320508
    .{
        .d3 = .{ 1, 1, 1 },
        .p3 = .{ 1, 1, 1, 0 },
        .outarr = .{1.7320508},
    },
    // plane x=2 (a=1,d=-2), point (5,0,0) → |5-2|/1 = 3
    .{
        .d3 = .{ 5, 0, 0 },
        .p3 = .{ 1, 0, 0, -2 },
        .outarr = .{3},
    },
    // negative side
    .{
        .d3 = .{ 0, 0, -4 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{4},
    },
    // classic 3-4-5 normal scaled
    // plane 3x+4y=0, point (0,0,0) → 0
    .{
        .d3 = .{ 0, 0, 0 },
        .p3 = .{ 3, 4, 0, 0 },
        .outarr = .{0},
    },
    // plane 3x+4y=0, point (4,-3,0) → |12-12|/5 = 0
    .{
        .d3 = .{ 4, -3, 0 },
        .p3 = .{ 3, 4, 0, 0 },
        .outarr = .{0},
    },
    // plane 3x+4y=0, point (3,0,0) → |9|/5 = 1.8
    .{
        .d3 = .{ 3, 0, 0 },
        .p3 = .{ 3, 4, 0, 0 },
        .outarr = .{1.8},
    },
    // NaN propagates
    .{
        .d3 = .{ std.math.nan(f32), 0, 0 },
        .p3 = .{ 1, 0, 0, 0 },
        .outarr = .{std.math.nan(f32)},
    },
    .{
        .d3 = .{ 1, 0, 0 },
        .p3 = .{ std.math.nan(f32), 0, 0, 0 },
        .outarr = .{std.math.nan(f32)},
    },
    // +inf
    .{
        .d3 = .{ std.math.inf(f32), 0, 0 },
        .p3 = .{ 1, 0, 0, 0 },
        .outarr = .{std.math.inf(f32)},
    },
    // zero normal → division by zero → inf or nan (match TS)
    .{
        .d3 = .{ 1, 2, 3 },
        .p3 = .{ 0, 0, 0, 5 },
        .outarr = .{std.math.inf(f32)}, // abs(5)/0 → +inf
    },
};
