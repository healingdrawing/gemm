// src/p3_d3d3d3/p3_d3d3d3.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Build 3D plane from three points.
/// INCOMINGS MUST BE SANITIZED.
/// Returns plane [a,b,c,d] where [a,b,c] is plane normal vector
/// based on cross of v(d3a-d3) x v(d3b-d3). Oriented CCW from d3→d3a→d3b.
/// And d is responsible for plane displacement from (0, 0, 0) along [a,b,c].
/// Matches TS p3_d3d3d3 exactly (no zero-length guard on cross).
pub inline fn p3_d3d3d3(
    d3: @Vector(3, f32),
    d3a: @Vector(3, f32),
    d3b: @Vector(3, f32),
) @Vector(4, f32) {
    const d3x = d3[0];
    const d3y = d3[1];
    const d3z = d3[2];

    const v3ax = d3a[0] - d3x;
    const v3ay = d3a[1] - d3y;
    const v3az = d3a[2] - d3z;
    const v3bx = d3b[0] - d3x;
    const v3by = d3b[1] - d3y;
    const v3bz = d3b[2] - d3z;

    // hardcoded v3normal (cross)
    var v3x = v3ay * v3bz - v3az * v3by;
    var v3y = -v3ax * v3bz + v3az * v3bx;
    var v3z = v3ax * v3by - v3ay * v3bx;

    // hardcoded v3one
    const lv = @sqrt(v3x * v3x + v3y * v3y + v3z * v3z);
    v3x /= lv;
    v3y /= lv;
    v3z /= lv;

    return .{
        v3x,
        v3y,
        v3z,
        -(v3x * d3x + v3y * d3y + v3z * d3z),
    };
}
