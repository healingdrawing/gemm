// src/v3mag/v3mag.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Magnitude (length / norm) of a 3D vector. INCOMINGS MUST BE SANITIZED.

pub inline fn v3mag_sequent(v3: @Vector(3, f32)) f32 {
    return @sqrt(v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2]);
}

pub inline fn v3mag_locals(v3: @Vector(3, f32)) f32 {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return @sqrt(x * x + y * y + z * z);
}

pub inline fn v3mag_reduce(v3: @Vector(3, f32)) f32 {
    return @sqrt(@reduce(.Add, v3 * v3));
}

pub inline fn v3mag_fma_chain(v3: @Vector(3, f32)) f32 {
    return @sqrt(@mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], v3[2] * v3[2])));
}

pub inline fn v3mag_hybrid(v3: @Vector(3, f32)) f32 {
    return @sqrt(@mulAdd(f32, v3[2], v3[2], v3[0] * v3[0] + v3[1] * v3[1]));
}

pub inline fn v3mag_std_sqrt(v3: @Vector(3, f32)) f32 {
    return std.math.sqrt(v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2]);
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Magnitude (length / norm) of a 3D vector.
/// sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3mag(v3: @Vector(3, f32)) f32 {
    return @sqrt(v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2]);
}
