// bench_v3mag2.zig
const std = @import("std");
const v3mag2 = @import("v3mag2.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3mag2 - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    // --- warmup (unmeasured) ---
    {
        var sum: f32 = 0;
        var v: @Vector(3, f32) = .{ 1, 2, 3 };
        for (0..2_000_000) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            sum += v3mag2.v3mag2_sequent(v);
            sum += v3mag2.v3mag2_fma_chain(v);
            sum += v3mag2.v3mag2_hybrid(v);
            sum += v3mag2.v3mag2_locals(v);
            sum += v3mag2.v3mag2_reduce(v);
        }
        volatile_sum += sum;
    }

    // 1. sequent
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag2.v3mag2_sequent(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag2_sequent\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. locals
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag2.v3mag2_locals(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag2_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. reduce
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag2.v3mag2_reduce(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag2_reduce\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. fma_chain
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag2.v3mag2_fma_chain(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag2_fma_chain\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 5. hybrid
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3mag2.v3mag2_hybrid(v3);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3mag2_hybrid\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
