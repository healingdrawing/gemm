// src/v3v3scalar/v3v3scalar.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Dot product of two 3D vectors (last component is ignored).
pub inline fn v3v3scalar(a: *const @Vector(4, f32), b: *const @Vector(4, f32), result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}
