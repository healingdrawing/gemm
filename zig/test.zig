const std = @import("std");
const dp = @import("utils/debug.zig");

const test_v3v3scalar = @import("tests/test_v3v3scalar.zig").test_v3v3scalar;
const test_v3one = @import("tests/test_v3one.zig").test_v3one;
const test_v3rot = @import("tests/test_v3rot.zig").test_v3rot;

pub fn main(init: std.process.Init) !void {
    dp.init_from_env_map(init.environ_map); // manage test.sh "DEVLOG" env value

    const epsilon = 1e-5;

    try test_v3v3scalar(epsilon);

    try test_v3one(epsilon);

    try test_v3rot(epsilon);
}
