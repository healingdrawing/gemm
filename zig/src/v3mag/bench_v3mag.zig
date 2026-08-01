// bench_v3mag.zig
const std = @import("std");
const v3mag = @import("v3mag.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3mag - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    // 1. sequent
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3mag.v3mag_sequent(v3);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_sequent\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 2. locals
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag.v3mag_locals(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. reduce
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3mag.v3mag_reduce(v3);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_reduce\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 4. fma_chain
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag.v3mag_fma_chain(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_fma_chain\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 5. hybrid
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag.v3mag_hybrid(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_hybrid\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 6. std.math.sqrt (for comparison vs @sqrt)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3mag.v3mag_std_sqrt(v3);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag_std_sqrt\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
