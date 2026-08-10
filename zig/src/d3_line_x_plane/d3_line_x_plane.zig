// src/d3_line_x_plane/d3_line_x_plane.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Intersection of 3D line (from `d3` along `v3`) with plane `p3`=[a,b,c,d].
/// Returns the intersection point.
/// INCOMINGS MUST BE SANITIZED. Parallel → Inf/NaN (matches TS).
pub inline fn d3_line_x_plane(d3: @Vector(3, f32), v3: @Vector(3, f32), p3: @Vector(4, f32)) @Vector(3, f32) {
    const dx = d3[0];
    const dy = d3[1];
    const dz = d3[2];
    const vx = v3[0];
    const vy = v3[1];
    const vz = v3[2];
    const a = p3[0];
    const b = p3[1];
    const c = p3[2];

    const t = -(a * dx + b * dy + c * dz + p3[3]) / (a * vx + b * vy + c * vz);

    return .{
        dx + vx * t,
        dy + vy * t,
        dz + vz * t,
    };
}
