// src/d3offset_mut/d3offset_mut.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Offset 3D dot `d3` along vector `v3` by distance `t`.
/// INCOMINGS MUST BE SANITIZED.
/// Returns 3d dot. If t == 0 or |v3| == 0 → returns original d3 unchanged.
pub inline fn d3offset(d3: @Vector(3, f32), v3: @Vector(3, f32), t: f32) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    const mag2 = x * x + y * y + z * z;
    if (t == 0.0 or mag2 == 0.0) return d3;

    const s = t / @sqrt(mag2);

    return .{
        d3[0] + x * s,
        d3[1] + y * s,
        d3[2] + z * s,
    };
}
