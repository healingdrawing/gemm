const std = @import("std");
const gemm = @import("gemm.zig");
const GEMM = gemm.GEMM;

pub fn main() !void {
    std.debug.print("=== Testing compiled libgemm.a (native) ===\n", .{});

    // v3v3scalar test
    const a: [3]f32 = .{ 1.0, 2.0, 3.0 };
    const b: [3]f32 = .{ 4.0, 5.0, 6.0 };
    const result = GEMM.v3v3scalar(&a, &b);
    std.debug.print("v3v3scalar({any}, {any}) = {}\n", .{ a, b, result });

    // varzig test (this should demonstrate the const mutation issue)
    std.debug.print("\n=== Testing varzig (expect mutation behavior) ===\n", .{});
    var v3: [3]u8 = .{ 1, 3, 4 };
    std.debug.print("Before: {any}\n", .{v3});

    GEMM.callme(&v3);
    std.debug.print("After callme: {any}\n", .{v3});

    std.debug.print("✅ Native library test completed\n", .{});
}
