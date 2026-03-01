// test_negative-inside-i.zig
const std = @import("std");
const testing = std.testing;
const negative_inside_I = @import("./negative-inside-i.zig").negative_inside_I;

test "negative_inside_I: array with negative element" {
    var arr = [_]i32{ 5, 2, 0, -3, 7 };
    try testing.expect(negative_inside_I(&arr));
}

test "negative_inside_I: array with only positive elements" {
    var arr = [_]i32{ 5, 2, 1, 10 };
    try testing.expect(!negative_inside_I(&arr));
}

test "negative_inside_I: array with only zeros" {
    var arr = [_]i32{ 0, 0, 0, 0 };
    try testing.expect(!negative_inside_I(&arr));
}

test "negative_inside_I: single negative element" {
    var arr = [_]i32{-1};
    try testing.expect(negative_inside_I(&arr));
}

test "negative_inside_I: single positive element" {
    var arr = [_]i32{1};
    try testing.expect(!negative_inside_I(&arr));
}

test "negative_inside_I: large array with negative at end" {
    var arr = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, -1 };
    try testing.expect(negative_inside_I(&arr));
}

test "negative_inside_I: large array with negative at start" {
    var arr = [_]i32{ -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17 };
    try testing.expect(negative_inside_I(&arr));
}

test "negative_inside_I: large array with no negatives" {
    var arr = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18 };
    try testing.expect(!negative_inside_I(&arr));
}

test "negative_inside_I: array with mixed positive and negative" {
    var arr = [_]i32{ 5, -10, 3, -2, 1, -8, 7, -1 };
    try testing.expect(negative_inside_I(&arr));
}

test "negative_inside_I: array with min i32" {
    var arr = [_]i32{ 1, std.math.minInt(i32) };
    try testing.expect(negative_inside_I(&arr));
}
