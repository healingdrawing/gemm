// bench_v3v3scalar.zig
const std = @import("std");
const v3v3scalar = @import("v3v3scalar.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3a: @Vector(3, f32) = .{ 1, 2, 3 };
    var v3b: @Vector(3, f32) = .{ 4, 5, 6 };

    std.debug.print("v3v3scalar - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    // 1. nested muladd
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3v3scalar.v3v3scalar_nested_muladd(v3a, v3b);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_nested_muladd\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 2. sequent_read
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3v3scalar.v3v3scalar_sequent_read(v3a, v3b);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_sequent_read\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. locals
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3v3scalar.v3v3scalar_locals(v3a, v3b);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 4. reduce
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: f32 = 0;
    //     for (0..iterations) |_| {
    //         v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3v3scalar.v3v3scalar_reduce(v3a, v3b);
    //         sum += result;
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_reduce\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 5. hybrid
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3v3scalar.v3v3scalar_hybrid(v3a, v3b);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_hybrid\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 6. fma_chain
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3b = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3v3scalar.v3v3scalar_fma_chain(v3a, v3b);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3v3scalar_fma_chain\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
