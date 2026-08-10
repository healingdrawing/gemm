// src/d3_projection_on_p3/d3_projection_on_p3.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Project 3D point `d3` onto plane `p3` = [a,b,c,d].
/// INCOMINGS MUST BE SANITIZED.
/// Returns the projected point. Plane normal (a,b,c) must be non-zero.
pub inline fn d3_projection_on_p3(d3: @Vector(3, f32), p3: @Vector(4, f32)) @Vector(3, f32) {
    const d3x = d3[0];
    const d3y = d3[1];
    const d3z = d3[2];
    const p3a = p3[0];
    const p3b = p3[1];
    const p3c = p3[2];
    const p3d = p3[3];

    const t = -(p3a * d3x + p3b * d3y + p3c * d3z + p3d) / (p3a * p3a + p3b * p3b + p3c * p3c);

    return .{
        d3x + p3a * t,
        d3y + p3b * t,
        d3z + p3c * t,
    };
}
