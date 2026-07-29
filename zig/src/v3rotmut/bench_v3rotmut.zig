// src/v3rotmut/bench_v3rotmut.zig
const std = @import("std");
const v3rotmut = @import("v3rotmut.zig");

pub fn main(init: std.process.Init) !void {
    const iterations = 20_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v: @Vector(3, f32) = .{ 1, 2, 3 };
    var naxis: @Vector(3, f32) = .{ 0, 0, 1 };
    var angle: f32 = 0.5;

    std.debug.print("v3rotmut - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // 1. cross temps dott
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            // random unit-ish axis (not normalized — ok for pure throughput)
            naxis = .{ rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1 };
            angle = rand.float(f32) * std.math.pi * 2 - std.math.pi;
            result = v3rotmut.v3rotmut_cross_temps_dott(v, naxis, angle);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3rotmut_cross_temps_dott\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. cross_temps
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            naxis = .{ rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1 };
            angle = rand.float(f32) * std.math.pi * 2 - std.math.pi;
            result = v3rotmut.v3rotmut_cross_temps(v, naxis, angle);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3rotmut_cross_temps\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. fma dott
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            naxis = .{ rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1 };
            angle = rand.float(f32) * std.math.pi * 2 - std.math.pi;
            result = v3rotmut.v3rotmut_fma_dott(v, naxis, angle);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3rotmut_fma_dott\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. fma
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            naxis = .{ rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1, rand.float(f32) * 2 - 1 };
            angle = rand.float(f32) * std.math.pi * 2 - std.math.pi;
            result = v3rotmut.v3rotmut_fma(v, naxis, angle);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3rotmut_fma\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
