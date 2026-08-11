// tests/data_v3v3similar.zig
const std = @import("std");

pub const TestCase = struct {
    a: @Vector(3, f32),
    b: @Vector(3, f32),
    outarr: [1]f32, // 1.0 = true, 0.0 = false
};

pub const cases = [_]TestCase{
    .{ // identical
        .a = .{ 1, 2, 3 },
        .b = .{ 1, 2, 3 },
        .outarr = .{1},
    },
    .{ // within epsilon (well under)
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 5e-7, 2.0 - 5e-7, 3.0 + 1e-7 },
        .outarr = .{1},
    },
    .{ // within epsilon (well under)
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 5e-7, 2.0, 3.0 + 1e-7 },
        .outarr = .{1},
    },
    .{ // exactly at boundary (strict < so false)
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 2e-6, 2.0, 3.0 },
        .outarr = .{0},
    },
    .{ // just under boundary
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 9.999e-7, 2.0, 3.0 },
        .outarr = .{1},
    },
    .{ // clearly outside
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0 + 1e-5, 2.0, 3.0 },
        .outarr = .{0},
    },
    .{ // zero == zero
        .a = .{ 0, 0, 0 },
        .b = .{ 0, 0, 0 },
        .outarr = .{1},
    },
    .{ // +0 vs -0 (diff == 0)
        .a = .{ 0, 0, 0 },
        .b = .{ -0.0, -0.0, -0.0 },
        .outarr = .{1},
    },
    .{ // negative identical
        .a = .{ -1.5, -2.5, -3.5 },
        .b = .{ -1.5, -2.5, -3.5 },
        .outarr = .{1},
    },
    .{ // negative within eps
        .a = .{ -1.5, -2.5, -3.5 },
        .b = .{ -1.5 + 3e-7, -2.5 - 4e-7, -3.5 },
        .outarr = .{1},
    },
    .{ // first component differs a lot
        .a = .{ 1, 0, 0 },
        .b = .{ 2, 0, 0 },
        .outarr = .{0},
    },
    .{ // only last component out
        .a = .{ 1.0, 2.0, 3.0 },
        .b = .{ 1.0, 2.0, 3.0 + 2e-6 },
        .outarr = .{0},
    },
    .{ // NaN in a → false
        .a = .{ std.math.nan(f32), 2, 3 },
        .b = .{ 1, 2, 3 },
        .outarr = .{0},
    },
    .{ // NaN in both → false (NaN - NaN = NaN, NaN < eps = false)
        .a = .{ std.math.nan(f32), 2, 3 },
        .b = .{ std.math.nan(f32), 2, 3 },
        .outarr = .{0},
    },
    .{ // Inf == Inf → true (diff == 0)
        .a = .{ std.math.inf(f32), 0, 0 },
        .b = .{ std.math.inf(f32), 0, 0 },
        .outarr = .{1},
    },
    .{ // +Inf vs -Inf → false
        .a = .{ std.math.inf(f32), 0, 0 },
        .b = .{ -std.math.inf(f32), 0, 0 },
        .outarr = .{0},
    },
    .{ // mixed Inf/NaN → false
        .a = .{ std.math.inf(f32), std.math.nan(f32), 0 },
        .b = .{ std.math.inf(f32), std.math.nan(f32), 0 },
        .outarr = .{0},
    },
    .{ // large numbers within absolute eps
        .a = .{ 1e6, 2e6, 3e6 },
        .b = .{ 1e6 + 5e-7, 2e6, 3e6 },
        .outarr = .{1},
    },
    .{ // large numbers, difference still within eps (and representable)
        .a = .{ 1e3, 2e3, 3e3 },
        .b = .{ 1e3 + 5e-7, 2e3, 3e3 },
        .outarr = .{1},
    },
    .{ // large numbers, difference outside eps
        .a = .{ 1e3, 2e3, 3e3 },
        .b = .{ 1e3 + 1e-4, 2e3, 3e3 },
        .outarr = .{0},
    },
};
