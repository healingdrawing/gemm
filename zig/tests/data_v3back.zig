const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    .{
        .v = .{ 1, 2, 3 },
        .outarr = .{ -1, -2, -3 },
    },
    .{
        .v = .{ -1, -2, -3 },
        .outarr = .{ 1, 2, 3 },
    },
    .{
        .v = .{ 0, 0, 0 },
        .outarr = .{ 0, 0, 0 },
    },
    .{
        .v = .{ 1, 0, 0 },
        .outarr = .{ -1, 0, 0 },
    },
    .{
        .v = .{ 0, 1, 0 },
        .outarr = .{ 0, -1, 0 },
    },
    .{
        .v = .{ 0, 0, 1 },
        .outarr = .{ 0, 0, -1 },
    },
    .{
        .v = .{ 3.5, -2.25, 0.5 },
        .outarr = .{ -3.5, 2.25, -0.5 },
    },
    .{
        .v = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{ std.math.nan(f32), -2, -3 },
    },
    .{
        .v = .{ 1, std.math.inf(f32), 3 },
        .outarr = .{ -1, -std.math.inf(f32), -3 },
    },
    .{
        .v = .{ 1, -std.math.inf(f32), 3 },
        .outarr = .{ -1, std.math.inf(f32), -3 },
    },
    .{
        .v = .{ std.math.inf(f32), -std.math.inf(f32), 0 },
        .outarr = .{ -std.math.inf(f32), std.math.inf(f32), 0 },
    },
};
