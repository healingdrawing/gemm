// AUTO-GENERATED FROM src/ - DO NOT EDIT MANUALLY

const std = @import("std");
// const simd = std.simd;   // add when needed

pub const GEMM = struct {

// --- FROM v3v3scalar/v3v3scalar.zig ---

// todo check at least two methods, with similar name imports. Then if it is ok consider to refactor to vectors and simd
pub fn v3v3scalar(v3a: []const f32, v3b: []const f32) f32 {
    std.debug.assert(v3a.len == 3 and v3b.len == 3);
    return v3a[0] * v3b[0] + v3a[1] * v3b[1] + v3a[2] * v3b[2];
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
