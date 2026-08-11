// src/p3_d3d3/p3_d3d3.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// INCOMINGS MUST BE SANITIZED.
/// Returns 3D plane [a,b,c,d] built from 3d dots `d3` and `d3n` (end of normal).
/// Where [a, b, c] is 3d plane normal vector, and (d) is responsible for displacement of the plane from (0, 0, 0) along [a, b, c].
pub inline fn p3_d3d3(d3: @Vector(3, f32), d3n: @Vector(3, f32)) @Vector(4, f32) {
    const d3x = d3[0];
    const d3y = d3[1];
    const d3z = d3[2];

    var v3x = d3n[0] - d3x;
    var v3y = d3n[1] - d3y;
    var v3z = d3n[2] - d3z;

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
