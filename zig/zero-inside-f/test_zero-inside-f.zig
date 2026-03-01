// test_zero-inside-f.zig
const std = @import("std");
const testing = std.testing;
const zero_inside_F = @import("./zero-inside-f.zig").zero_inside_F;

test "zero_inside_F: array with zero element" {
    var arr = [_]f32{ -5.5, -2.3, 0.0, 3.7, 7.1 };
    try testing.expect(zero_inside_F(&arr));
}

test "zero_inside_F: array with only negative elements" {
    var arr = [_]f32{ -5.5, -2.3, -1.1, -10.9 };
    try testing.expect(!zero_inside_F(&arr));
}

test "zero_inside_F: array with only zeros" {
    var arr = [_]f32{ 0.0, 0.0, 0.0, 0.0 };
    try testing.expect(zero_inside_F(&arr));
}

test "zero_inside_F: single zero element" {
    var arr = [_]f32{0.0};
    try testing.expect(zero_inside_F(&arr));
}

test "zero_inside_F: single non-zero element" {
    var arr = [_]f32{-1.5};
    try testing.expect(!zero_inside_F(&arr));
}

test "zero_inside_F: large array with zero at end" {
    var arr = [_]f32{ -1.1, -2.2, -3.3, -4.4, -5.5, -6.6, -7.7, -8.8, -9.9, -10.1, -11.2, -12.3, -13.4, -14.5, -15.6, -16.7, -17.8, 0.0 };
    try testing.expect(zero_inside_F(&arr));
}

test "zero_inside_F: large array with zero at start" {
    var arr = [_]f32{ 0.0, -1.1, -2.2, -3.3, -4.4, -5.5, -6.6, -7.7, -8.8, -9.9, -10.1, -11.2, -12.3, -13.4, -14.5, -15.6, -16.7, -17.8 };
    try testing.expect(zero_inside_F(&arr));
}

test "zero_inside_F: large array with no zeros" {
    var arr = [_]f32{ -1.1, -2.2, -3.3, -4.4, -5.5, -6.6, -7.7, -8.8, -9.9, -10.1, -11.2, -12.3, -13.4, -14.5, -15.6, -16.7, -17.8, -18.9 };
    try testing.expect(!zero_inside_F(&arr));
}

test "zero_inside_F: array with mixed positive and negative, no zero" {
    var arr = [_]f32{ 5.5, -10.2, 3.3, -2.8, 1.1, -8.9, 7.6, -1.4 };
    try testing.expect(!zero_inside_F(&arr));
}

test "zero_inside_F: array with zero in middle" {
    var arr = [_]f32{ -1.5, std.math.floatMin(f32), 0.0, std.math.floatMax(f32), 1.5 };
    try testing.expect(zero_inside_F(&arr));
}
