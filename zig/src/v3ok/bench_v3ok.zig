// bench_v3ok.zig
const std = @import("std");
const v3ok = @import("v3ok.zig");
const save_to_file = @import("b/dumper.zig").save_to_file;

pub fn main(init: std.process.Init) !void {
    const iterations = 100_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3ok - {} iterations\n\n", .{iterations});

    var volatile_sum: usize = 0;
    var result: bool = undefined;

    // --- warmup (unmeasured) ---
    {
        var sum: usize = 0;
        var v: @Vector(3, f32) = .{ 1, 2, 3 };
        for (0..2_000_000) |_| {
            v = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            sum += @intFromBool(v3ok.v3ok_sequent(v));
            sum += @intFromBool(v3ok.v3ok_locals(v));
            sum += @intFromBool(v3ok.v3ok_reduce(v));
            sum += @intFromBool(v3ok.v3ok_fma_chain(v));
            sum += @intFromBool(v3ok.v3ok_hybrid(v));
            sum += @intFromBool(v3ok.v3ok_or_zero_check(v));
            sum += @intFromBool(v3ok.v3ok_or_zero_check_fma(v));
            sum += @intFromBool(v3ok.v3ok_or_zero_check_hybrid(v));
        }
        volatile_sum += sum;
    }

    // 1. sequent (old style)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_sequent(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_sequent\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3ok_sequent", elapsed);
    }

    // 2. locals (old style)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_locals(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_locals\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3ok_locals", elapsed);
    }

    // 3. fma_chain (old style)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_fma_chain(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_fma_chain\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3ok_fma_chain", elapsed);
    }

    // 7. reduce (old style)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_reduce(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_reduce\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3ok_reduce", elapsed);
    }

    // 8. hybrid (old style)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: usize = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3ok.v3ok_hybrid(v3);
            sum += @intFromBool(result);
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3ok_hybrid\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3ok_hybrid", elapsed);
    }

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
        try save_to_file(init, "v3ok_or_zero_check", elapsed);
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
        try save_to_file(init, "v3ok_or_zero_check_fma", elapsed);
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
        try save_to_file(init, "v3ok_or_zero_check_hybrid", elapsed);
    }

    std.debug.print("\nFinal volatile sum: {}\n", .{volatile_sum});
}
