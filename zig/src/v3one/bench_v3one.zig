// bench_one.zig
const std = @import("std");
const v3one = @import("v3one.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3one normalization - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // 1. Vector ops (fast)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_always_division_machine_mag(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_always_division_machine_mag\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. Scalar ops (slow)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_always_division_solid_mag(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_always_division_solid_mag\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. sequent (step by step)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_filtered_division_sequent_mag(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_filtered_division_sequent_mag\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }
    // 4. sequent (solid mag)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_filtered_division_solid_mag(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_filtered_division_solid_mag\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
