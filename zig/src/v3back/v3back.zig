// src/v3back/v3back.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Negate a 3D vector (opposite direction). INCOMINGS MUST BE SANITIZED.

/// Pure vector unary minus (compiler usually turns this into a single SIMD instruction)
pub inline fn v3back_vector_neg(v3: @Vector(3, f32)) @Vector(3, f32) {
    return -v3;
}

/// Explicit component multiply by -1
pub inline fn v3back_mul_neg1(v3: @Vector(3, f32)) @Vector(3, f32) {
    return .{ -v3[0], -v3[1], -v3[2] };
}

/// Locals + manual negate
pub inline fn v3back_locals(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return .{ -x, -y, -z };
}

/// In-place mutation via pointer (lowest allocation / no return copy)
pub inline fn v3back_mut(v3: *@Vector(3, f32)) void {
    v3.* = -v3.*;
}

/// In-place component-wise
pub inline fn v3back_mut_components(v3: *@Vector(3, f32)) void {
    v3[0] = -v3[0];
    v3[1] = -v3[1];
    v3[2] = -v3[2];
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Opposite of a 3D vector. [1, 2, -4] → [-1, -2, 4]
/// INCOMINGS MUST BE SANITIZED. NaN / Inf propagate.
pub inline fn v3back(v3: @Vector(3, f32)) @Vector(3, f32) {
    return -v3;
}
