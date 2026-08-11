// tests/data_p3_d3v3.zig
const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    v3: @Vector(3, f32),
    outarr: [4]f32,
};

pub const cases = [_]TestCase{
    // unit normal + origin
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 1, 0, 0 },
        .outarr = .{ 1, 0, 0, 0 },
    },
    // unit normal, non-zero point
    .{
        .d3 = .{ 2, 3, 4 },
        .v3 = .{ 0, 1, 0 },
        .outarr = .{ 0, 1, 0, -3 },
    },
    // non-unit normal (3,4,0) → unit (0.6,0.8,0)
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ 3, 4, 0 },
        .outarr = .{ 0.6, 0.8, 0, 0 },
    },
    // non-unit + offset
    .{
        .d3 = .{ 1, 2, 3 },
        .v3 = .{ 3, 4, 0 },
        .outarr = .{ 0.6, 0.8, 0, -(0.6 * 1 + 0.8 * 2) }, // -2.2
    },
    // negative direction
    .{
        .d3 = .{ 5, 0, 0 },
        .v3 = .{ -1, 0, 0 },
        .outarr = .{ -1, 0, 0, 5 },
    },
    // diagonal unit
    .{
        .d3 = .{ 1, 1, 1 },
        .v3 = .{ 1, 1, 1 },
        .outarr = .{ 0.5773502588, 0.5773502588, 0.5773502588, -1.732050776 },
    },
    // zero vector → NaNs
    .{
        .d3 = .{ 1, 2, 3 },
        .v3 = .{ 0, 0, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in v3
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ std.math.nan(f32), 0, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // +Inf component
    .{
        .d3 = .{ 0, 0, 0 },
        .v3 = .{ std.math.inf(f32), 0, 0 },
        .outarr = .{ std.math.nan(f32), 0, 0, std.math.nan(f32) },
    },
};
