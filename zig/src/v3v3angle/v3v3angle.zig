// src/v3v3angle/v3v3angle.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Angle (radians) between two 3D vectors.
/// acos( v3v3cos(a, b) )
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3v3angle(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
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

    // sin_cos_cut hardcoded vs gemm.ts separated. In the past was detected outside bounds [-1,1] result in the very first python3 origin code, then was haxe version geometryXD.hx and so on.
    const c = if (rawc > 1.0 - 1e-6) 1.0 else if (rawc < -1.0 + 1e-6) -1.0 else rawc;
    return std.math.acos(c);
}
