// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

// --- FROM v3back/v3back.zig ---

/// Opposite of a 3D vector. [1, 2, -4] → [-1, -2, 4]
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3back(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = -v3[0];
    const y = -v3[1];
    const z = -v3[2];

    return .{ x, y, z };
}



// --- FROM v3mag/v3mag.zig ---

/// Magnitude (length / norm) of a 3D vector.
/// sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3mag(v3: @Vector(3, f32)) f32 {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    return @sqrt(x * x + y * y + z * z);
}



// --- FROM v3mag2/v3mag2.zig ---

/// Squared magnitude of a 3D vector.
/// v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2]
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3mag2(v3: @Vector(3, f32)) f32 {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];
    return x * x + y * y + z * z;
}



// --- FROM v3ok/v3ok.zig ---

/// Returns true if the 3D vector is finite AND non-zero.
/// Matches current TS: (x != 0 || y != 0 || z != 0) && isFinite(x*x+y*y+z*z)
pub inline fn v3ok(v3: @Vector(3, f32)) bool {
    const mag2 = v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2];
    return mag2 > 0 and !std.math.isPositiveInf(mag2);
}



// --- FROM v3one/v3one.zig ---

/// Normalize a 3D vector to unit length if magnitude > 0.
/// Otherwise, return unchanged vector.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag2 = x * x + y * y + z * z;

    if (mag2 > 0.0) {
        const mag = @sqrt(mag2);
        const inv = 1.0 / mag;
        return .{ x * inv, y * inv, z * inv };
    }

    return v3;
}



// --- FROM v3rot/v3rot.zig ---

/// Rotate 3D vector `v` around normalized axis `naxis` by `angle` (radians).
/// Returns new vector. Axis must already be unit length.
/// Uses Rodrigues' rotation formula.
pub inline fn v3rot(v: @Vector(3, f32), naxis: @Vector(3, f32), angle: f32) @Vector(3, f32) {
    const nax = naxis[0];
    const nay = naxis[1];
    const naz = naxis[2];
    const vx = v[0];
    const vy = v[1];
    const vz = v[2];

    const cos = @cos(angle);
    const sin = @sin(angle);
    // const t = 1.0 - cos;

    const dott = (nax * vx + nay * vy + naz * vz) * (1.0 - cos);

    const cx = nay * vz - naz * vy;
    const cy = naz * vx - nax * vz;
    const cz = nax * vy - nay * vx;

    return .{
        vx * cos + cx * sin + nax * dott,
        vy * cos + cy * sin + nay * dott,
        vz * cos + cz * sin + naz * dott,
    };
}



// --- FROM v3v3angle/v3v3angle.zig ---

/// Angle (radians) between two 3D vectors.
/// acos( v3v3cos(a, b) )
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3v3angle(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];

    const dot = ax * bx + ay * by + az * bz;
    const maga = @sqrt(ax * ax + ay * ay + az * az);
    const magb = @sqrt(bx * bx + by * by + bz * bz);
    const rawc = dot / (maga * magb);

    // sin_cos_cut hardcoded vs gemm.ts separated. In the past was detected outside bounds [-1,1] result in the very first python3 origin code, then was haxe version geometryXD.hx and so on.
    const c = if (rawc > 1.0 - 1e-6) 1.0 else if (rawc < -1.0 + 1e-6) -1.0 else rawc;
    return std.math.acos(c);
}



// --- FROM v3v3cos/v3v3cos.zig ---

/// Cosine of angle between two 3D vectors.
/// sin_cos_cut( (a·b) / (|a| * |b|) )
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn v3v3cos(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];

    const dot = ax * bx + ay * by + az * bz;
    const maga = @sqrt(ax * ax + ay * ay + az * az);
    const magb = @sqrt(bx * bx + by * by + bz * bz);
    const c = dot / (maga * magb);

    // sin_cos_cut hardcoded vs gemm.ts separated. In the past was detected outside bounds [-1,1] result in the very first python3 origin code, then was haxe version geometryXD.hx and so on.
    return if (c > 1.0 - 1e-6) 1.0 else if (c < -1.0 + 1e-6) -1.0 else c;
}



// --- FROM v3v3same/v3v3same.zig ---

/// Exact equality of two 3D vectors.
/// a[0]==b[0] && a[1]==b[1] && a[2]==b[2]
/// INCOMINGS MUST BE SANITIZED. NaN !== NaN (IEEE).
pub inline fn v3v3same(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return a[0] == b[0] and a[1] == b[1] and a[2] == b[2];
}



// --- FROM v3v3scalar/v3v3scalar.zig ---

/// Dot product of two 3D vectors. a[0]*b[0] + a[1]*b[1] + a[2]*b[2]
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}



// --- FROM v3v3similar/v3v3similar.zig ---

/// Approximate equality of two 3D vectors.
/// Math.abs(a[i] - b[i]) < 1e-6 for all i.
/// INCOMINGS MUST BE SANITIZED. Precision: 0.000001 (1e-6).
/// NaN differences → false.
pub inline fn v3v3similar(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
    return (a[0] == b[0] or @abs(a[0] - b[0]) < 1e-6) and (a[1] == b[1] or @abs(a[1] - b[1]) < 1e-6) and (a[2] == b[2] or @abs(a[2] - b[2]) < 1e-6);
}


};
