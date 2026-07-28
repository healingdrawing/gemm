// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

// --- FROM v3one/v3one.zig ---

/// Normalize a 3D vector to unit length.
/// If magnitude is zero, vector remains unchanged.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag_squared = x * x + y * y + z * z;
    const mag = std.math.sqrt(mag_squared);

    if (mag > 0) {
        return .{ x / mag, y / mag, z / mag };
    }
    return v3;
}



// --- FROM v3v3scalar/v3v3scalar.zig ---

/// Dot product of two 3D vectors (last component is ignored).
pub inline fn v3v3scalar(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
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
