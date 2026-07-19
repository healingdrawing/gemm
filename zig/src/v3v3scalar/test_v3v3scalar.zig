// src/v3v3scalar/v3v3scalar_test.zig
const std = @import("std");
const v3v3scalar = @import("v3v3scalar.zig").v3v3scalar;

test "v3v3scalar basic cases" {
    const testing = std.testing;

    const a = [_]f32{ 1.0, 2.0, 3.0 };
    const b = [_]f32{ 4.0, -5.0, 6.0 };

    try testing.expectApproxEqAbs(@as(f32, 12.0), v3v3scalar(&a, &b), 1e-6);
    try testing.expectApproxEqAbs(@as(f32, 0.0), v3v3scalar(&a, &[_]f32{ 0, 0, 0 }), 1e-6);
}
