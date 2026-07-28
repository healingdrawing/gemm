// bench_one.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const iterations = 20_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3a: @Vector(3, f32) = .{ 1, 2, 3 };
    var v3b: @Vector(3, f32) = .{ 4, 5, 6 };

    std.debug.print("v3one normalization - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // 1. Vector ops (fast)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            const mag = @sqrt(@mulAdd(f32, v3a[0], v3a[0], @mulAdd(f32, v3a[1], v3a[1], @mulAdd(f32, v3a[2], v3a[2], 0))));
            result = if (mag > 0) v3a / @as(@Vector(3, f32), @splat(mag)) else v3a;
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("1. v3one (vector ops) : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. Scalar ops (slow)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            const x = v3b[0];
            const y = v3b[1];
            const z = v3b[2];
            const mag_squared = x * x + y * y + z * z;
            const mag = @sqrt(mag_squared);
            result = if (mag > 0) .{ x / mag, y / mag, z / mag } else v3b;
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("2. v3one (scalar ops) : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
