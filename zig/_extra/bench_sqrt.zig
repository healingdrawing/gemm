// bench_sqrt.zig — fair @sqrt vs std.math.sqrt
const std = @import("std");

const iterations: u64 = 1_000_000_000;
const warmup_iters: u64 = 50_000_000;
const seed: u64 = 42;

fn genX(rand: std.Random) f32 {
    return rand.float(f32) * 100.0 + 0.001;
}

fn timeSqrt(
    init: std.process.Init,
    comptime label: []const u8,
    comptime use_builtin: bool,
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
        result = if (use_builtin) @sqrt(x) else std.math.sqrt(x);
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
    std.debug.print("sqrt f32 fair bench - {} timed iters, {} warmup\n\n", .{ iterations, warmup_iters });

    var volatile_sum: f32 = 0;
    var x: f32 = 1.0;
    var result: f32 = undefined;

    // --- warmup (untimed): heat CPU / caches / BTB ---
    {
        var rng = std.Random.DefaultPrng.init(seed);
        const rand = rng.random();
        var sum: f32 = 0;
        for (0..warmup_iters) |_| {
            x = genX(rand);
            result = @sqrt(x);
            sum += result;
            x = genX(rand);
            result = std.math.sqrt(x);
            sum += result;
        }
        volatile_sum += sum;
    }

    // --- pass A: @sqrt first, then std (same seed → same input stream each) ---
    std.debug.print("--- order: @sqrt then std.math.sqrt (seed={})\n", .{seed});
    volatile_sum += timeSqrt(init, "@sqrt", true, seed);
    volatile_sum += timeSqrt(init, "std.math.sqrt", false, seed);

    // --- pass B: swapped order, same seed again ---
    std.debug.print("\n--- order: std.math.sqrt then @sqrt (seed={})\n", .{seed});
    volatile_sum += timeSqrt(init, "std.math.sqrt", false, seed);
    volatile_sum += timeSqrt(init, "@sqrt", true, seed);

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
    std.debug.print("Interpret: if the *second* of each pair always wins, residual order bias;\n", .{});
    std.debug.print("if both orders agree on a winner, that gap may be real (unlikely for f32).\n", .{});
}
