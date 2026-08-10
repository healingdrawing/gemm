// src/v3normal/v3normal.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Cross product of two 3D vectors, then normalize to unit length.
/// Result is oriented so that looking along the result, rotation from a → b is CCW.
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3normal(a: @Vector(3, f32), b: @Vector(3, f32)) @Vector(3, f32) {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];

    // a × b
    const cx = ay * bz - az * by;
    const cy = az * bx - ax * bz;
    const cz = ax * by - ay * bx;

    // hardcoded v3one
    const mag2 = cx * cx + cy * cy + cz * cz;
    if (mag2 > 0.0) {
        const mag = @sqrt(mag2);
        const inv = 1.0 / mag;
        return .{ cx * inv, cy * inv, cz * inv };
    }
    return .{ cx, cy, cz };
}
