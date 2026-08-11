const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    .{
        .v = .{ 3, 4, 0 },
        .outarr = .{ 0.6, 0.8, 0 },
    },
    .{
        .v = .{ 1, 1, 1 },
        .outarr = .{ 0.5773502588, 0.5773502588, 0.5773502588 },
    },
    .{
        .v = .{ -3, -4, 0 },
        .outarr = .{ -0.6, -0.8, 0 },
    },
    .{
        .v = .{ -1, -1, -1 },
        .outarr = .{ -0.5773502588, -0.5773502588, -0.5773502588 },
    },
    .{
        .v = .{ 0, 0, 0 },
        .outarr = .{ 0, 0, 0 },
    },
    // inf / mag → nan on that component, 0/inf → 0
    .{
        .v = .{ std.math.inf(f32), 0, 0 },
        .outarr = .{ std.math.nan(f32), 0, 0 },
    },
    .{
        .v = .{ -std.math.inf(f32), 0, 0 },
        .outarr = .{ std.math.nan(f32), 0, 0 },
    },
    // mag is nan → (mag > 0) is false → original vector returned
    .{
        .v = .{ std.math.nan(f32), 1, 1 },
        .outarr = .{ std.math.nan(f32), 1, 1 },
    },
    .{
        .v = .{ 0, 0, std.math.inf(f32) },
        .outarr = .{ 0, 0, std.math.nan(f32) },
    },
};
