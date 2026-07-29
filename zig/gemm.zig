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

    const mag = std.math.sqrt(x * x + y * y + z * z);

    x /= mag;
    y /= mag;
    z /= mag;

    if (mag > 0) {
        return .{ x, y, z };
    }
    return v3;
}



// --- FROM v3v3scalar/v3v3scalar.zig ---

/// Dot product of two 3D vectors.
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[0], b[0], @mulAdd(f32, a[1], b[1], a[2] * b[2]));
}



// --- FROM varzig/varzig.zig ---
pub fn varzig() void {
    //todo it should fail some way when lib tested since const used, keep it for now
    var v3: [3]u8 = .{ 1, 3, 4 };
    callme(&v3);
    return v3;
}

pub fn callme(v3: *[3]u8) void {
    v3[0] = 2;
}


};
