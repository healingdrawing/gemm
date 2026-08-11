// src/v3rot/v3rot.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Rotate 3D vector `v` around normalized axis `naxis` by `angle` (radians).
/// Returns new vector. Axis must already be unit length.
/// Uses Rodrigues' rotation formula.
pub inline fn v3rot(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);
    // const t = 1.0 - cos;

    const dott = (nax * vx + nay * vy + naz * vz) * (1.0 - cos);

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        vx * cos + cx * sin + nax * dott,
        vy * cos + cy * sin + nay * dott,
        vz * cos + cz * sin + naz * dott,
    };
}
