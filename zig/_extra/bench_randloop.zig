const std = @import("std");

pub fn main() void {
    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();
    var v3: @Vector(3, f32) = .{ 1, 2, 3 };
    var sum: f32 = 0.0;
    for (0..25) |_| {
        v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };

        sum += v3[0];
        std.debug.print("{any} ", .{v3});
    }
    std.debug.print("sum:{any} ", .{sum});
}
