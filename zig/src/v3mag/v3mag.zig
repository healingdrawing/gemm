// src/v3mag/v3mag.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Magnitude (length / norm) of a 3D vector.
/// sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3mag(v3: @Vector(3, f32)) f32 {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    return @sqrt(x * x + y * y + z * z);
}
