// src/v3ok/v3ok.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Returns true if vector is finite AND non-zero.

// Original style (mag2 != 0)
pub inline fn v3ok_sequent(v3: @Vector(3, f32)) bool {
    const mag2 = v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2];
    return mag2 != 0 and std.math.isFinite(mag2);
}

pub inline fn v3ok_locals(v3: @Vector(3, f32)) bool {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    const mag2 = x * x + y * y + z * z;
    return mag2 != 0 and std.math.isFinite(mag2);
}

pub inline fn v3ok_reduce(v3: @Vector(3, f32)) bool {
    const mag2 = @reduce(.Add, v3 * v3);
    return mag2 != 0 and std.math.isFinite(mag2);
}

pub inline fn v3ok_fma_chain(v3: @Vector(3, f32)) bool {
    const mag2 = @mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], v3[2] * v3[2]));
    return mag2 != 0 and std.math.isFinite(mag2);
}

pub inline fn v3ok_hybrid(v3: @Vector(3, f32)) bool {
    const mag2 = @mulAdd(f32, v3[2], v3[2], v3[0] * v3[0] + v3[1] * v3[1]);
    return mag2 != 0 and std.math.isFinite(mag2);
}

// New TS style: (x != 0 || y != 0 || z != 0) && isFinite(mag2)
pub inline fn v3ok_or_zero_check(v3: @Vector(3, f32)) bool {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return (x != 0 or y != 0 or z != 0) and std.math.isFinite(x * x + y * y + z * z);
}

pub inline fn v3ok_or_zero_check_fma(v3: @Vector(3, f32)) bool {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return (x != 0 or y != 0 or z != 0) and std.math.isFinite(@mulAdd(f32, x, x, @mulAdd(f32, y, y, z * z)));
}

pub inline fn v3ok_or_zero_check_hybrid(v3: @Vector(3, f32)) bool {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return (x != 0 or y != 0 or z != 0) and std.math.isFinite(@mulAdd(f32, z, z, x * x + y * y));
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Returns true if the 3D vector is finite AND non-zero.
/// Matches current TS: (x != 0 || y != 0 || z != 0) && isFinite(x*x+y*y+z*z)
pub inline fn v3ok(v3: @Vector(3, f32)) bool {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return (x != 0 or y != 0 or z != 0) and std.math.isFinite(@mulAdd(f32, x, x, @mulAdd(f32, y, y, z * z)));
}
