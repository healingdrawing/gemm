// src/v3v3scalar/v3v3scalar.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

// todo check at least two methods, with similar name imports. Then if it is ok consider to refactor to vectors and simd
pub fn v3v3scalar(v3a: []const f32, v3b: []const f32) f32 {
    std.debug.assert(v3a.len == 3 and v3b.len == 3);
    return v3a[0] * v3b[0] + v3a[1] * v3b[1] + v3a[2] * v3b[2];
}
