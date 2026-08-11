// src/v3v3same/v3v3same.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Exact equality of two 3D vectors.
/// a[0]==b[0] && a[1]==b[1] && a[2]==b[2]
/// INCOMINGS MUST BE SANITIZED. NaN !== NaN (IEEE).
pub inline fn v3v3same(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return a[0] == b[0] and a[1] == b[1] and a[2] == b[2];
}
