// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

// --- FROM d3offset/d3offset.zig ---

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



// --- FROM d3_projection_on_p3/d3_projection_on_p3.zig ---

/// Project 3D point `d3` onto plane `p3` = [a,b,c,d].
/// INCOMINGS MUST BE SANITIZED.
/// Returns the projected point. Plane normal (a,b,c) must be non-zero.
pub inline fn d3_projection_on_p3(d3: @Vector(3, f32), p3: @Vector(4, f32)) @Vector(3, f32) {
    const d3x = d3[0];
    const d3y = d3[1];
    const d3z = d3[2];
    const p3a = p3[0];
    const p3b = p3[1];
    const p3c = p3[2];
    const p3d = p3[3];

    const t = -(p3a * d3x + p3b * d3y + p3c * d3z + p3d) / (p3a * p3a + p3b * p3b + p3c * p3c);

    return .{
        d3x + p3a * t,
        d3y + p3b * t,
        d3z + p3c * t,
    };
}



// --- FROM distance_d3_p3/distance_d3_p3.zig ---

/// Distance from 3D dot `d3` to 3D plane `p3`.
/// |a*x + b*y + c*z + d| / sqrt(a*a + b*b + c*c)
/// INCOMINGS MUST BE SANITIZED. NaN raises NaN.
pub inline fn distance_d3_p3(d3: @Vector(3, f32), p3: @Vector(4, f32)) f32 {
    const dx = d3[0];
    const dy = d3[1];
    const dz = d3[2];
    const a = p3[0];
    const b = p3[1];
    const c = p3[2];
    const d = p3[3];

    const num = @abs(a * dx + b * dy + c * dz + d);
    const den = @sqrt(a * a + b * b + c * c);
    return num / den;
}



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



// --- FROM v3normal/v3normal.zig ---

/// Cross product of two 3D vectors, then normalize to unit length.
/// Result is oriented so that looking along the result, rotation from a → b is CCW.
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3normal(a: @Vector(3, f32), b: @Vector(3, f32)) @Vector(3, f32) {
    const ax = a[0];
    const ay = a[1];
    const az = a[2];
    const bx = b[0];
    const by = b[1];
    const bz = b[2];

    // a × b
    const cx = ay * bz - az * by;
    const cy = az * bx - ax * bz;
    const cz = ax * by - ay * bx;

    // hardcoded v3one
    const mag2 = cx * cx + cy * cy + cz * cz;
    if (mag2 > 0.0) {
        const mag = @sqrt(mag2);
        const inv = 1.0 / mag;
        return .{ cx * inv, cy * inv, cz * inv };
    }
    return .{ cx, cy, cz };
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



// --- FROM v3v3paralleled/v3v3paralleled.zig ---

/// Returns true if two 3D vectors are parallel (same or opposite direction).
/// Precision: 0.000001 (1e-6) → cos > 0.999999 || cos < -0.999999
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3v3paralleled(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
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

    // sin_cos_cut
    const c = if (rawc > 1.0) 1.0 else if (rawc < -1.0) -1.0 else rawc;
    return c > 0.999999 or c < -0.999999;
}



// --- FROM v3v3paralleled_opposite/v3v3paralleled_opposite.zig ---

/// Returns true if two 3D vectors are parallel and point in opposite directions.
/// Precision: 0.000001 (1e-6) → cos < -0.999999
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3v3paralleled_opposite(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
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

    // sin_cos_cut
    const c = if (rawc > 1.0) 1.0 else if (rawc < -1.0) -1.0 else rawc;
    return c < -0.999999;
}



// --- FROM v3v3paralleled_sameside/v3v3paralleled_sameside.zig ---

/// Returns true if two 3D vectors are parallel and point in the same direction.
/// Precision: 0.000001 (1e-6) → cos > 0.999999
/// INCOMINGS MUST BE SANITIZED.
pub inline fn v3v3paralleled_sameside(a: @Vector(3, f32), b: @Vector(3, f32)) bool {
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

    // sin_cos_cut
    const c = if (rawc > 1.0) 1.0 else if (rawc < -1.0) -1.0 else rawc;
    return c > 0.999999;
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
