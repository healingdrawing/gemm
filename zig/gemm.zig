// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

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
