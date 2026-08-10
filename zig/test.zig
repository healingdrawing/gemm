const std = @import("std");
const dp = @import("utils/debug.zig");
const report = @import("tests/report.zig");

const test_v3v3scalar = @import("tests/test_v3v3scalar.zig").test_v3v3scalar;
const test_v3one = @import("tests/test_v3one.zig").test_v3one;
const test_v3rot = @import("tests/test_v3rot.zig").test_v3rot;
const test_v3mag2 = @import("tests/test_v3mag2.zig").test_v3mag2;
const test_v3mag = @import("tests/test_v3mag.zig").test_v3mag;
const test_v3ok = @import("tests/test_v3ok.zig").test_v3ok;
const test_v3back = @import("tests/test_v3back.zig").test_v3back;
const test_v3v3same = @import("tests/test_v3v3same.zig").test_v3v3same;
const test_v3v3similar = @import("tests/test_v3v3similar.zig").test_v3v3similar;
const test_v3v3cos = @import("tests/test_v3v3cos.zig").test_v3v3cos;
const test_v3v3angle = @import("tests/test_v3v3angle.zig").test_v3v3angle;
const test_v3v3paralleled_sameside = @import("tests/test_v3v3paralleled_sameside.zig").test_v3v3paralleled_sameside;
const test_v3v3paralleled_opposite = @import("tests/test_v3v3paralleled_opposite.zig").test_v3v3paralleled_opposite;
const test_v3v3paralleled = @import("tests/test_v3v3paralleled.zig").test_v3v3paralleled;
const test_v3normal = @import("tests/test_v3normal.zig").test_v3normal;
const test_d3offset = @import("tests/test_d3offset.zig").test_d3offset;
const test_distance_d3_p3 = @import("tests/test_distance_d3_p3.zig").test_distance_d3_p3;
const test_d3_projection_on_p3 = @import("tests/test_d3_projection_on_p3.zig").test_d3_projection_on_p3;

pub fn main(init: std.process.Init) !void {
    dp.init_from_env_map(init.environ_map);

    const epsilon: f32 = 1e-6;

    const results = [_]report.MethodResult{
        try test_v3v3scalar(epsilon),
        try test_v3one(epsilon),
        try test_v3rot(epsilon),
        try test_v3mag2(epsilon),
        try test_v3mag(epsilon),
        try test_v3ok(epsilon),
        try test_v3back(epsilon),
        try test_v3v3same(epsilon),
        try test_v3v3similar(epsilon),
        try test_v3v3cos(epsilon),
        try test_v3v3angle(epsilon),
        try test_v3v3paralleled_sameside(epsilon),
        try test_v3v3paralleled_opposite(epsilon),
        try test_v3v3paralleled(epsilon),
        try test_v3normal(epsilon),
        try test_d3offset(epsilon),
        try test_distance_d3_p3(epsilon),
        try test_d3_projection_on_p3(epsilon),
    };

    report.print_test_sum_report(&results);
}
