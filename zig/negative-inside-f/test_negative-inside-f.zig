// test_negative-inside-F.zig
const std = @import("std");
const testing = std.testing;
const negative_inside_F = @import("./negative-inside-f.zig").negative_inside_F;

test "negative_inside_F: array with negative element" {
    var arr = [_]f32{ 5.0, 2.0, 0.0, -3.0, 7.0 };
    try testing.expect(negative_inside_F(&arr));
}

test "negative_inside_F: array with only positive elements" {
    var arr = [_]f32{ 5.0, 2.0, 1.0, 10.0 };
    try testing.expect(!negative_inside_F(&arr));
}

test "negative_inside_F: array with only zeros" {
    var arr = [_]f32{ 0.0, 0.0, 0.0, 0.0 };
    try testing.expect(!negative_inside_F(&arr));
}

test "negative_inside_F: single negative element" {
    var arr = [_]f32{-1.0};
    try testing.expect(negative_inside_F(&arr));
}

test "negative_inside_F: single positive element" {
    var arr = [_]f32{1.0};
    try testing.expect(!negative_inside_F(&arr));
}

test "negative_inside_F: large array with negative at end" {
    var arr = [_]f32{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, -1.0 };
    try testing.expect(negative_inside_F(&arr));
}

test "negative_inside_F: large array with negative at start" {
    var arr = [_]f32{ -1.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0 };
    try testing.expect(negative_inside_F(&arr));
}

test "negative_inside_F: large array with no negatives" {
    var arr = [_]f32{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0 };
    try testing.expect(!negative_inside_F(&arr));
}

test "negative_inside_F: array with mixed positive and negative" {
    var arr = [_]f32{ 5.0, -10.0, 3.0, -2.0, 1.0, -8.0, 7.0, -1.0 };
    try testing.expect(negative_inside_F(&arr));
}

test "negative_inside_F: array with negative infinity" {
    var arr = [_]f32{ 1.0, -std.math.inf(f32) };
    try testing.expect(negative_inside_F(&arr));
}
