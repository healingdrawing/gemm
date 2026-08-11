const std = @import("std");

pub const TestCase = struct {
    v: @Vector(3, f32),
    naxis: @Vector(3, f32),
    angle: f32,
    outarr: [3]f32,
};

pub const cases = [_]TestCase{
    // Identity: rotation by 0 radians should return the original vector
    .{
        .v = .{ 1, 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = 0,
        .outarr = .{ 1, 2, 3 },
    },
    // 90° rotation around Z-axis
    .{
        .v = .{ 1, 0, 0 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi / 2.0,
        .outarr = .{ 0, 1, 0 },
    },
    // 180° rotation around Z-axis
    .{
        .v = .{ 1, 0, 0 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi,
        .outarr = .{ -1, 0, 0 },
    },
    // 90° rotation around X-axis
    .{
        .v = .{ 0, 1, 0 },
        .naxis = .{ 1, 0, 0 },
        .angle = std.math.pi / 2.0,
        .outarr = .{ 0, 0, 1 },
    },
    // 90° rotation around Y-axis
    .{
        .v = .{ 1, 0, 0 },
        .naxis = .{ 0, 1, 0 },
        .angle = std.math.pi / 2.0,
        .outarr = .{ 0, 0, -1 },
    },
    // Rotation around axis parallel to vector (should not change magnitude, but direction unchanged)
    .{
        .v = .{ 1, 2, 3 },
        .naxis = .{ 1.0 / @sqrt(14.0), 2.0 / @sqrt(14.0), 3.0 / @sqrt(14.0) },
        .angle = std.math.pi / 4.0,
        .outarr = .{ 1, 2, 3 }, // Parallel to axis, unchanged
    },
    // Small angle approximation: sin(θ) ≈ θ, cos(θ) ≈ 1
    .{
        .v = .{ 1, 0, 0 },
        .naxis = .{ 0, 1, 0 },
        .angle = 0.001,
        .outarr = .{ 0.9999995, 0, -0.001 },
    },
    // 360° rotation should return to original (approximately)
    .{
        .v = .{ 1, 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = 2 * std.math.pi,
        .outarr = .{ 1, 2, 3 },
    },
    // NaN in vector
    .{
        .v = .{ std.math.nan(f32), 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi / 4.0,
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in axis
    .{
        .v = .{ 1, 2, 3 },
        .naxis = .{ std.math.nan(f32), 0, 1 },
        .angle = std.math.pi / 4.0,
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // NaN in angle
    .{
        .v = .{ 1, 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.nan(f32),
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // +inf in vector
    .{
        .v = .{ std.math.inf(f32), 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi / 4.0,
        .outarr = .{ std.math.nan(f32), std.math.nan(f32), std.math.nan(f32) },
    },
    // -inf in vector
    .{
        .v = .{ -std.math.inf(f32), 2, 3 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi / 4.0,
        .outarr = .{ std.math.nan(f32), -std.math.nan(f32), std.math.nan(f32) },
    },
    // Zero vector (should remain zero)
    .{
        .v = .{ 0, 0, 0 },
        .naxis = .{ 0, 0, 1 },
        .angle = std.math.pi / 2.0,
        .outarr = .{ 0, 0, 0 },
    },
    // Arbitrary rotation: 45° around (1,1,1) normalized
    .{
        .v = .{ 1, 0, 0 },
        .naxis = .{ 1.0 / @sqrt(3.0), 1.0 / @sqrt(3.0), 1.0 / @sqrt(3.0) },
        .angle = std.math.pi / 4.0,
        .outarr = .{ 0.8047378, 0.5058794, -0.3106172 },
    },
};
