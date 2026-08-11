// src/v3v3similar/v3v3similar.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Approximate equality of two 3D vectors.
/// Math.abs(a[i] - b[i]) < 1e-6 for all i.
/// INCOMINGS MUST BE SANITIZED. Precision: 0.000001 (1e-6).
/// NaN differences → false.
pub inline fn v3v3similar(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return (a[0] == b[0] or @abs(a[0] - b[0]) < 1e-6) and (a[1] == b[1] or @abs(a[1] - b[1]) < 1e-6) and (a[2] == b[2] or @abs(a[2] - b[2]) < 1e-6);
}
