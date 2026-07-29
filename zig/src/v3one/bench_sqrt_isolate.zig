// bench_sqrt.zig — isolate the actual sqrt instruction
const std = @import("std");

const iterations: u64 = 1_000_000_000;
const warmup_iters: u64 = 50_000_000;
const seed: u64 = 42;

fn genX(rand: std.Random) f32 {
    return rand.float(f32) * 100.0 + 0.001;
}

fn timeSqrtBuiltin(
    init: std.process.Init,
    comptime label: []const u8,
    rng_seed: u64,
) f32 {
    var rng = std.Random.DefaultPrng.init(rng_seed);
    const rand = rng.random();
    var x: f32 = 1.0;
    var result: f32 = undefined;
    var sum: f32 = 0;

    const start = std.Io.Clock.real.now(init.io);
    for (0..iterations) |_| {
        x = genX(rand);
        result = @sqrt(x);
        sum += result;
    }
    const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    std.debug.print("{d:>12} ns  ({d:.3} ns/op) {s}\n", .{
        elapsed,
        @as(f64, @floatFromInt(elapsed)) / @as(f64, @floatFromInt(iterations)),
        label,
    });
    return sum;
}

fn timeSqrtStdMath(
    init: std.process.Init,
    comptime label: []const u8,
    rng_seed: u64,
) f32 {
    var rng = std.Random.DefaultPrng.init(rng_seed);
    const rand = rng.random();
    var x: f32 = 1.0;
    var result: f32 = undefined;
    var sum: f32 = 0;

    const start = std.Io.Clock.real.now(init.io);
    for (0..iterations) |_| {
        x = genX(rand);
        result = std.math.sqrt(x);
        sum += result;
    }
    const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
    std.debug.print("{d:>12} ns  ({d:.3} ns/op) {s}\n", .{
        elapsed,
        @as(f64, @floatFromInt(elapsed)) / @as(f64, @floatFromInt(iterations)),
        label,
    });
    return sum;
}

pub fn main(init: std.process.Init) !void {
    std.debug.print("sqrt f32 isolated test - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;

    // --- warmup ---
    {
        var rng = std.Random.DefaultPrng.init(seed);
        const rand = rng.random();
        var sum: f32 = 0;
        for (0..warmup_iters) |_| {
            sum += @sqrt(rand.float(f32) * 100.0 + 0.001);
            sum += std.math.sqrt(rand.float(f32) * 100.0 + 0.001);
        }
        volatile_sum += sum;
    }

    // --- pass A ---
    std.debug.print("--- order: @sqrt then std.math.sqrt\n", .{});
    volatile_sum += timeSqrtBuiltin(init, "@sqrt", seed);
    volatile_sum += timeSqrtStdMath(init, "std.math.sqrt", seed);

    // --- pass B ---
    std.debug.print("\n--- order: std.math.sqrt then @sqrt\n", .{});
    volatile_sum += timeSqrtStdMath(init, "std.math.sqrt", seed);
    volatile_sum += timeSqrtBuiltin(init, "@sqrt", seed);

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
