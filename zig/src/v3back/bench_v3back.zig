// bench_v3back.zig
const std = @import("std");
const v3back = @import("v3back.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3back - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // 1. vector_neg (return)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3back.v3back_vector_neg(v3);
    //         sum += result[0] + result[1] + result[2];
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_vector_neg\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 2. mul_neg1 (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3back.v3back_mul_neg1(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_mul_neg1\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. locals (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3back.v3back_locals(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. mut (pointer)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         v3back.v3back_mut(&v3);
    //         sum += v3[0] + v3[1] + v3[2];
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_mut\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 5. mut_components (pointer)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3back.v3back_mut_components(&v3);
            sum += v3[0] + v3[1] + v3[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_mut_components\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
