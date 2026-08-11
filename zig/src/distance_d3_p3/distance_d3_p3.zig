// src/distance_d3_p3/distance_d3_p3.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Distance from 3D dot `d3` to 3D plane `p3`.
/// |a*x + b*y + c*z + d| / sqrt(a*a + b*b + c*c)
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn distance_d3_p3(d3: @Vector(3, f32), p3: @Vector(4, f32)) f32 {
    const dx = d3[0];
    const dy = d3[1];
    const dz = d3[2];
    const a = p3[0];
    const b = p3[1];
    const c = p3[2];
    const d = p3[3];

    const num = @abs(a * dx + b * dy + c * dz + d);
    const den = @sqrt(a * a + b * b + c * c);
    return num / den;
}
