// src/v3ok/v3ok.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Returns true if the 3D vector is finite AND non-zero.
/// Matches current TS: (x != 0 || y != 0 || z != 0) && isFinite(x*x+y*y+z*z)
pub inline fn v3ok(v3: @Vector(3, f32)) bool {
    const mag2 = v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2];
    return mag2 > 0 and !std.math.isPositiveInf(mag2);
}
