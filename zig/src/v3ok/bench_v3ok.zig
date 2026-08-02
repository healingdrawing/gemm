// bench_v3ok.zig
const std = @import("std");
const v3ok = @import("v3ok.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3ok - {} iterations\n\n", .{iterations});

    var volatile_sum: usize = 0;
    var result: bool = undefined;

    // 1. sequent (old style)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: usize = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3ok.v3ok_sequent(v3);
    //         sum += @intFromBool(result);
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_sequent\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 2. locals (old style)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: usize = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3ok.v3ok_locals(v3);
    //         sum += @intFromBool(result);
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 3. fma_chain (old style)
    // {
    //     const start = std.Io.Clock.real.now(init.io);
    //     var sum: usize = 0;
    //     for (0..iterations) |_| {
    //         v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
    //         result = v3ok.v3ok_fma_chain(v3);
    //         sum += @intFromBool(result);
    //     }
    //     volatile_sum += sum;
    //     const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    //     std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_fma_chain\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    // }

    // 4. NEW: or_zero_check
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_or_zero_check(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_or_zero_check\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 5. NEW: or_zero_check_fma
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_or_zero_check_fma(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_or_zero_check_fma\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 6. NEW: or_zero_check_hybrid
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_or_zero_check_hybrid(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_or_zero_check_hybrid\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {}\n", .{volatile_sum});
}
