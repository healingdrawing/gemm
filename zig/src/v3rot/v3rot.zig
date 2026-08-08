// src/v3rot/v3rot.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Rodrigues rotation. naxis must be unit length.

/// Same math, cross product temps explicit
pub inline fn v3rot_cross_temps(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);
    const t = 1.0 - cos;

    const dot = nax * vx + nay * vy + naz * vz;

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        vx * cos + cx * sin + nax * dot * t,
        vy * cos + cy * sin + nay * dot * t,
        vz * cos + cz * sin + naz * dot * t,
    };
}

pub inline fn v3rot_cross_temps_dott(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
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

/// FMA-friendly chain (may reduce noise on some CPUs)
pub inline fn v3rot_fma(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);
    const t = 1.0 - cos;

    const dot = @mulAdd(f32, nax, vx, @mulAdd(f32, nay, vy, naz * vz));

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        @mulAdd(f32, vx, cos, @mulAdd(f32, cx, sin, nax * dot * t)),
        @mulAdd(f32, vy, cos, @mulAdd(f32, cy, sin, nay * dot * t)),
        @mulAdd(f32, vz, cos, @mulAdd(f32, cz, sin, naz * dot * t)),
    };
}

pub inline fn v3rot_fma_dott(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);
    // const t = 1.0 - cos;

    const dott = @mulAdd(f32, nax, vx, @mulAdd(f32, nay, vy, naz * vz)) * (1.0 - cos);

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        @mulAdd(f32, vx, cos, @mulAdd(f32, cx, sin, nax * dott)),
        @mulAdd(f32, vy, cos, @mulAdd(f32, cy, sin, nay * dott)),
        @mulAdd(f32, vz, cos, @mulAdd(f32, cz, sin, naz * dott)),
    };
}

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
