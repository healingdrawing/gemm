// src/v3one/v3one.zig
const std = @import("std");

// bench_one.zig showed this is slower(almost always)
// pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
//     const mag = @sqrt(@mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], @mulAdd(f32, v3[2], v3[2], 0))));
//     return if (mag > 0) v3 / @as(@Vector(3, f32), @splat(mag)) else v3;
// }

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Normalize a 3D vector to unit length.
/// If magnitude is zero, vector remains unchanged.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag_squared = x * x + y * y + z * z;
    const mag = std.math.sqrt(mag_squared);

    if (mag > 0) {
        return .{ x / mag, y / mag, z / mag };
    }
    return v3;
}
