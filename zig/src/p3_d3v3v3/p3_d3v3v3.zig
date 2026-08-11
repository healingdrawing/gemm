// src/p3_d3v3v3/p3_d3v3v3.zig
const std = @import("std");

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// INCOMINGS MUST BE SANITIZED.
/// Returns 3d plane [a,b,c,d] built from 3d dot `d3` and two 3d vectors `v3a` → `v3b` (CCW normal).
/// Where [a, b, c] is 3d plane normal vector, and (d) is responsible for displacement of the plane from (0, 0, 0) along [a, b, c].
pub inline fn p3_d3v3v3(d3: @Vector(3, f32), v3a: @Vector(3, f32), v3b: @Vector(3, f32)) @Vector(4, f32) {
    const ax = v3a[0];
    const ay = v3a[1];
    const az = v3a[2];
    const bx = v3b[0];
    const by = v3b[1];
    const bz = v3b[2];

    // hardcoded v3normal (a × b)
    var nx = ay * bz - az * by;
    var ny = az * bx - ax * bz;
    var nz = ax * by - ay * bx;

    // hardcoded v3one
    const mag = @sqrt(nx * nx + ny * ny + nz * nz);

    nx /= mag;
    ny /= mag;
    nz /= mag;

    return .{
        nx,
        ny,
        nz,
        -(nx * d3[0] + ny * d3[1] + nz * d3[2]),
    };
}
