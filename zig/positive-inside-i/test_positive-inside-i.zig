// test_positive-inside-i.zig
const std = @import("std");
const testing = std.testing;
const positive_inside_I = @import("./positive-inside-i.zig").positive_inside_I;

test "positive_inside_I: array with positive elements" {
    var arr = [_]i32{ -5, -2, 0, 3, 7 };
    try testing.expect(positive_inside_I(&arr));
}

test "positive_inside_I: array with only negative elements" {
    var arr = [_]i32{ -5, -2, -1, -10 };
    try testing.expect(!positive_inside_I(&arr));
}

test "positive_inside_I: array with only zeros" {
    var arr = [_]i32{ 0, 0, 0, 0 };
    try testing.expect(!positive_inside_I(&arr));
}

test "positive_inside_I: single positive element" {
    var arr = [_]i32{1};
    try testing.expect(positive_inside_I(&arr));
}

test "positive_inside_I: single negative element" {
    var arr = [_]i32{-1};
    try testing.expect(!positive_inside_I(&arr));
}

test "positive_inside_I: large array with positive at end" {
    var arr = [_]i32{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, 1 };
    try testing.expect(positive_inside_I(&arr));
}

test "positive_inside_I: large array with positive at start" {
    var arr = [_]i32{ 1, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17 };
    try testing.expect(positive_inside_I(&arr));
}

test "positive_inside_I: large array all negative" {
    var arr = [_]i32{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16, -17, -18 };
    try testing.expect(!positive_inside_I(&arr));
}

test "positive_inside_I: array with mixed positive and negative" {
    var arr = [_]i32{ 5, -10, 3, -2, 1, -8, 7, -1 };
    try testing.expect(positive_inside_I(&arr));
}

test "positive_inside_I: array with max i32" {
    var arr = [_]i32{ -1, std.math.maxInt(i32) };
    try testing.expect(positive_inside_I(&arr));
}
