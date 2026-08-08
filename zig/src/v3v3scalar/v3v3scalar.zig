// src/v3v3scalar/v3v3scalar.zig
const std = @import("std");

// bench context: fastest and/or more less noisy
pub inline fn v3v3scalar_nested_muladd(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
}

pub inline fn v3v3scalar_sequent_read(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

pub inline fn v3v3scalar_locals(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];
    return ax * bx + ay * by + az * bz;
}

pub inline fn v3v3scalar_reduce(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @reduce(.Add, a * b);
}

pub inline fn v3v3scalar_hybrid(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], a[0] * b[0] + a[1] * b[1]);
}

pub inline fn v3v3scalar_fma_chain(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[0], b[0], @mulAdd(f32, a[1], b[1], a[2] * b[2]));
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Dot product of two 3D vectors. a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}
