const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    outarr: [1]f32, // 1.0 = true, 0.0 = false
};

pub const cases = [_]TestCase{
    .{
        .v = .{ 1, 2, 3 },
        .outarr = .{1}, // true
    },
    .{
        .v = .{ 0, 0, 0 },
        .outarr = .{0}, // zero → false
    },
    .{
        .v = .{ -1, -2, -3 },
        .outarr = .{1}, // true
    },
    .{
        .v = .{ 1, 0, 0 },
        .outarr = .{1},
    },
    .{
        .v = .{ 0, 1, 0 },
        .outarr = .{1},
    },
    .{
        .v = .{ 0, 0, 1 },
        .outarr = .{1},
    },
    .{
        .v = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{0}, // NaN → false
    },
    .{
        .v = .{ 1, std.math.inf(f32), 3 },
        .outarr = .{0}, // Inf → false
    },
    .{
        .v = .{ 1, -std.math.inf(f32), 3 },
        .outarr = .{0}, // -Inf → false
    },
    .{
        .v = .{ std.math.inf(f32), -std.math.inf(f32), 0 },
        .outarr = .{0}, // Inf → false
    },
    .{
        .v = .{ 0, 0, std.math.nan(f32) },
        .outarr = .{0},
    },
    .{
        .v = .{ 1e-40, 0, 0 }, // too small(out of f32) but non-zero
        .outarr = .{0},
    },
};
