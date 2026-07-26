// src/v3v3scalar/v3v3scalar.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Dot product of two 3D vectors (last component is ignored).
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
}
