// test_zero-inside-i.zig
const std = @import("std");
const testing = std.testing;
const zero_inside_I = @import("./zero-inside-i.zig").zero_inside_I;

test "zero_inside_I: array with zero element" {
    var arr = [_]i32{ -5, -2, 0, 3, 7 };
    try testing.expect(zero_inside_I(&arr));
}

test "zero_inside_I: array with only negative elements" {
    var arr = [_]i32{ -5, -2, -1, -10 };
    try testing.expect(!zero_inside_I(&arr));
}

test "zero_inside_I: array with only zeros" {
    var arr = [_]i32{ 0, 0, 0, 0 };
    try testing.expect(zero_inside_I(&arr));
}

test "zero_inside_I: single zero element" {
    var arr = [_]i32{0};
    try testing.expect(zero_inside_I(&arr));
}

test "zero_inside_I: single non-zero element" {
    var arr = [_]i32{-1};
    try testing.expect(!zero_inside_I(&arr));
}

test "zero_inside_I: large array with zero at end" {
    var arr = [_]i32{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, 0 };
    try testing.expect(zero_inside_I(&arr));
}

test "zero_inside_I: large array with zero at start" {
    var arr = [_]i32{ 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17 };
    try testing.expect(zero_inside_I(&arr));
}

test "zero_inside_I: large array with no zeros" {
    var arr = [_]i32{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18 };
    try testing.expect(!zero_inside_I(&arr));
}

test "zero_inside_I: array with mixed positive and negative, no zero" {
    var arr = [_]i32{ 5, -10, 3, -2, 1, -8, 7, -1 };
    try testing.expect(!zero_inside_I(&arr));
}

test "zero_inside_I: array with zero in middle" {
    var arr = [_]i32{ -1, std.math.minInt(i32), 0, std.math.maxInt(i32), 1 };
    try testing.expect(zero_inside_I(&arr));
}
