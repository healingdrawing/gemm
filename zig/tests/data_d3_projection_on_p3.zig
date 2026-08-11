const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    p3: @Vector(4, f32),
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    // point already on plane z=0 → stays
    .{
        .d3 = .{ 1, 2, 0 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{ 1, 2, 0 },
    },
    // project (0,0,5) onto z=0 → (0,0,0)
    .{
        .d3 = .{ 0, 0, 5 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{ 0, 0, 0 },
    },
    // project (1,1,1) onto x+y+z=0 → (-1/3,-1/3,-1/3) wait no: plane x+y+z=0 → d=0
    // t = -(1+1+1)/3 = -1 → result = (1,1,1) + (-1,-1,-1) = (0,0,0)
    .{
        .d3 = .{ 1, 1, 1 },
        .p3 = .{ 1, 1, 1, 0 },
        .outarr = .{ 0, 0, 0 },
    },
    // project (2,3,4) onto plane x=0 → (0,3,4)
    .{
        .d3 = .{ 2, 3, 4 },
        .p3 = .{ 1, 0, 0, 0 },
        .outarr = .{ 0, 3, 4 },
    },
    // project (0,0,0) onto plane x+y+z-3=0 → (1,1,1)
    .{
        .d3 = .{ 0, 0, 0 },
        .p3 = .{ 1, 1, 1, -3 },
        .outarr = .{ 1, 1, 1 },
    },
    // project (5,0,0) onto plane x=2 → (2,0,0)
    .{
        .d3 = .{ 5, 0, 0 },
        .p3 = .{ 1, 0, 0, -2 },
        .outarr = .{ 2, 0, 0 },
    },
    // NaN in point
    .{
        .d3 = .{ std.math.nan(f32), 1, 1 },
        .p3 = .{ 0, 0, 1, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in plane normal
    .{
        .d3 = .{ 1, 2, 3 },
        .p3 = .{ std.math.nan(f32), 0, 1, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // Inf in point
    .{
        .d3 = .{ std.math.inf(f32), 0, 0 },
        .p3 = .{ 1, 0, 0, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // zero normal → division by zero → Inf/NaN
    .{
        .d3 = .{ 1, 2, 3 },
        .p3 = .{ 0, 0, 0, 5 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
};
