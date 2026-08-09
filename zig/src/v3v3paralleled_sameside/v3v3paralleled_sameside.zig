// src/v3v3paralleled_sameside/v3v3paralleled_sameside.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Returns true if two 3D vectors are parallel and point in the same direction.
/// Precision: 0.000001 (1e-6) → cos > 0.999999
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3v3paralleled_sameside(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];

    const dot = ax * bx + ay * by + az * bz;
    const maga = @sqrt(ax * ax + ay * ay + az * az);
    const magb = @sqrt(bx * bx + by * by + bz * bz);
    const rawc = dot / (maga * magb);

    // sin_cos_cut
    const c = if (rawc > 1.0) 1.0 else if (rawc < -1.0) -1.0 else rawc;
    return c > 0.999999;
}
