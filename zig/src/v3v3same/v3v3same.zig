// src/v3v3same/v3v3same.zig
const std = @import("std");

// bench section: fastest and/or more stable (less noise)
// Exact equality of two 3D vectors. NaN !== NaN (IEEE).

pub inline fn v3v3same_sequent(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return a[0] == b[0] and a[1] == b[1] and a[2] == b[2];
}

pub inline fn v3v3same_locals(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];
    return ax == bx and ay == by and az == bz;
}

pub inline fn v3v3same_vector_eq(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    // @Vector comparison yields @Vector(3, bool); reduce with AND
    return @reduce(.And, a == b);
}

pub inline fn v3v3same_bitcast(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    // Compare bit patterns (still NaN != NaN because bit patterns differ for different NaNs,
    // but identical NaN bit patterns would match — matches TS === only for identical bits)
    // const ai: @Vector(3, u32) = @bitCast(a);
    // const bi: @Vector(3, u32) = @bitCast(b);
    // return @reduce(.And, ai == bi);
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];
    return !(ax != bx or ay != by or az != bz);
}

pub inline fn v3v3same_hybrid(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    // early-out friendly sequential with locals for first two, last direct
    // const ax = a[0];
    // const bx = b[0];
    // if (ax != bx) return false;
    // const ay = a[1];
    // const by = b[1];
    // if (ay != by) return false;
    // return a[2] == b[2];
    return !(a[0] != b[0] or a[1] != b[1] or a[2] != b[2]);
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Exact equality of two 3D vectors.
/// a[0]==b[0] && a[1]==b[1] && a[2]==b[2]
/// INCOMINGS MUST BE SANITIZED. NaN !== NaN (IEEE).
pub inline fn v3v3same(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return a[0] == b[0] and a[1] == b[1] and a[2] == b[2];
}
