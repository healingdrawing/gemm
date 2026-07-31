const std = @import("std");
const dp = @import("utils/debug.zig");
const report = @import("tests/report.zig");

const test_v3v3scalar = @import("tests/test_v3v3scalar.zig").test_v3v3scalar;
const test_v3one = @import("tests/test_v3one.zig").test_v3one;
const test_v3rot = @import("tests/test_v3rot.zig").test_v3rot;
const test_v3mag2 = @import("tests/test_v3mag2.zig").test_v3mag2;

pub fn main(init: std.process.Init) !void {
    dp.init_from_env_map(init.environ_map);

    const epsilon: f32 = 1e-5;

    const results = [_]report.MethodResult{
        try test_v3v3scalar(epsilon),
        try test_v3one(epsilon),
        try test_v3rot(epsilon),
        try test_v3mag2(epsilon),
    };

    report.print_test_sum_report(&results);
}
