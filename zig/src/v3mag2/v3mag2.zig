// src/v3mag2/v3mag2.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Squared magnitude of a 3D vector. INCOMINGS MUST BE SANITIZED.

pub inline fn v3mag2_sequent(v3: @Vector(3, f32)) f32 {
    return v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2];
}

pub inline fn v3mag2_locals(v3: @Vector(3, f32)) f32 {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return x * x + y * y + z * z;
}

pub inline fn v3mag2_reduce(v3: @Vector(3, f32)) f32 {
    return @reduce(.Add, v3 * v3);
}

pub inline fn v3mag2_fma_chain(v3: @Vector(3, f32)) f32 {
    return @mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], v3[2] * v3[2]));
}

pub inline fn v3mag2_hybrid(v3: @Vector(3, f32)) f32 {
    return @mulAdd(f32, v3[2], v3[2], v3[0] * v3[0] + v3[1] * v3[1]);
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Squared magnitude of a 3D vector.
/// v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2]
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3mag2(v3: @Vector(3, f32)) f32 {
    return @mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], v3[2] * v3[2]));
}
