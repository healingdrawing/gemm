// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

// --- FROM v3one/v3one.zig ---

/// Normalize a 3D vector to unit length if magnitude > 0.
/// Otherwise, return unchanged vector.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    var x = v3[0];
    var y = v3[1];
    var z = v3[2];

    const mag = @sqrt(x * x + y * y + z * z);

    x /= mag;
    y /= mag;
    z /= mag;

    if (mag > 0) {
        return .{ x, y, z };
    }
    return v3;
}



// --- FROM v3rotmut/v3rotmut.zig ---

/// Rotate 3D vector `v` around normalized axis `naxis` by `angle` (radians).
/// Returns new vector. Axis must already be unit length.
/// Uses Rodrigues' rotation formula.
pub inline fn v3rotmut(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);

    const dott = @mulAdd(f32, nax, vx, @mulAdd(f32, nay, vy, naz * vz)) * (1.0 - cos);

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        @mulAdd(f32, vx, cos, @mulAdd(f32, cx, sin, nax * dott)),
        @mulAdd(f32, vy, cos, @mulAdd(f32, cy, sin, nay * dott)),
        @mulAdd(f32, vz, cos, @mulAdd(f32, cz, sin, naz * dott)),
    };
}



// --- FROM v3v3scalar/v3v3scalar.zig ---

/// Dot product of two 3D vectors. a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[0], b[0], @mulAdd(f32, a[1], b[1], a[2] * b[2]));
}


};
