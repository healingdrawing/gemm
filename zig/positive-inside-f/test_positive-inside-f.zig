// test_positive-inside-f.zig
const std = @import("std");
const testing = std.testing;
const positive_inside_F = @import("./positive-inside-f.zig").positive_inside_F;

test "positive_inside_F: array with positive elements" {
    var arr = [_]f32{ -5.0, -2.0, 0.0, 3.0, 7.0 };
    try testing.expect(positive_inside_F(&arr));
}

test "positive_inside_F: array with only negative elements" {
    var arr = [_]f32{ -5.0, -2.0, -1.0, -10.0 };
    try testing.expect(!positive_inside_F(&arr));
}

test "positive_inside_F: array with only zeros" {
    var arr = [_]f32{ 0.0, 0.0, 0.0, 0.0 };
    try testing.expect(!positive_inside_F(&arr));
}

test "positive_inside_F: single positive element" {
    var arr = [_]f32{1.0};
    try testing.expect(positive_inside_F(&arr));
}

test "positive_inside_F: single negative element" {
    var arr = [_]f32{-1.0};
    try testing.expect(!positive_inside_F(&arr));
}

test "positive_inside_F: large array with positive at end" {
    var arr = [_]f32{ -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0, -11.0, -12.0, -13.0, -14.0, -15.0, -16.0, -17.0, 1.0 };
    try testing.expect(positive_inside_F(&arr));
}

test "positive_inside_F: large array with positive at start" {
    var arr = [_]f32{ 1.0, -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0, -11.0, -12.0, -13.0, -14.0, -15.0, -16.0, -17.0 };
    try testing.expect(positive_inside_F(&arr));
}

test "positive_inside_F: large array all negative" {
    var arr = [_]f32{ -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0, -11.0, -12.0, -13.0, -14.0, -15.0, -16.0, -17.0, -18.0 };
    try testing.expect(!positive_inside_F(&arr));
}

test "positive_inside_F: array with mixed positive and negative" {
    var arr = [_]f32{ 5.0, -10.0, 3.0, -2.0, 1.0, -8.0, 7.0, -1.0 };
    try testing.expect(positive_inside_F(&arr));
}

test "positive_inside_F: array with max f32" {
    var arr = [_]f32{ -1.0, std.math.floatMax(f32) };
    try testing.expect(positive_inside_F(&arr));
}
