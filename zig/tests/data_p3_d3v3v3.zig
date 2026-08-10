// tests/data_p3_d3v3v3.zig
const std = @import("std");

pub const TestCase = struct {
    d3: @Vector(3, f32),
    v3a: @Vector(3, f32),
    v3b: @Vector(3, f32),
    outarr: [4]f32,
};

pub const cases = [_]TestCase{
    // xy-plane, normal +z, through origin
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 1, 0, 0 },
        .v3b = .{ 0, 1, 0 },
        .outarr = .{ 0, 0, 1, 0 },
    },
    // yz-plane, normal +x, through origin
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 0, 1, 0 },
        .v3b = .{ 0, 0, 1 },
        .outarr = .{ 1, 0, 0, 0 },
    },
    // zx-plane, normal +y, through origin
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 0, 0, 1 },
        .v3b = .{ 1, 0, 0 },
        .outarr = .{ 0, 1, 0, 0 },
    },
    // opposite order → -normal
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 0, 1, 0 },
        .v3b = .{ 1, 0, 0 },
        .outarr = .{ 0, 0, -1, 0 },
    },
    // plane z = 5 (normal +z)
    .{
        .d3 = .{ 0, 0, 5 },
        .v3a = .{ 1, 0, 0 },
        .v3b = .{ 0, 1, 0 },
        .outarr = .{ 0, 0, 1, -5 },
    },
    // non-unit vectors, classic
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 3, 0, 0 },
        .v3b = .{ 0, 4, 0 },
        .outarr = .{ 0, 0, 1, 0 },
    },
    // offset point + mixed
    .{
        .d3 = .{ 1, 2, 3 },
        .v3a = .{ 1, 0, 0 },
        .v3b = .{ 0, 1, 0 },
        .outarr = .{ 0, 0, 1, -3 },
    },
    // parallel vectors → zero normal (mag==0 path) → d = 0
    .{
        .d3 = .{ 1, 2, 3 },
        .v3a = .{ 1, 2, 3 },
        .v3b = .{ 2, 4, 6 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN propagation
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ 1, 0, 0 },
        .v3b = .{ 0, std.math.nan(f32), 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // +inf in vector
    .{
        .d3 = .{ 0, 0, 0 },
        .v3a = .{ std.math.inf(f32), 0, 0 },
        .v3b = .{ 0, 1, 0 },
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
};
