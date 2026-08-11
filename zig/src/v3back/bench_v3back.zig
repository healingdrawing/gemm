// bench_v3back.zig
const std = @import("std");
const v3back = @import("v3back.zig");
const save_to_file = @import("b/dumper.zig").save_to_file;

pub fn main(init: std.process.Init) !void {
    const iterations = 100_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3back - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // --- warmup (unmeasured) ---
    {
        var sum: f32 = 0;
        for (0..2_000_000) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };

            result = v3back.v3back_machine_1(v3);
            sum += result[0] + result[1] + result[2];
            result = v3back.v3back_machine_2(v3);
            sum += result[0] + result[1] + result[2];
            v3back.v3back_machine_3(&v3);
            sum += v3[0] + v3[1] + v3[2];
            v3back.v3back_machine_4(&v3);
            sum += v3[0] + v3[1] + v3[2];

            result = v3back.v3back_locals(v3);
            sum += result[0] + result[1] + result[2];

            v3back.v3back_mut_components(&v3);
            sum += v3[0] + v3[1] + v3[2];
        }
        volatile_sum += sum;
    }

    // machine_1 (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3back.v3back_machine_1(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_machine_1\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3back_machine_1", elapsed);
    }

    // machine_2 (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3back.v3back_machine_2(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_machine_2\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3back_machine_2", elapsed);
    }

    // machine_3 (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3back.v3back_machine_3(&v3);
            sum += v3[0] + v3[1] + v3[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_machine_3\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3back_machine_3", elapsed);
    }

    // machine_4 (return)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            v3back.v3back_machine_4(&v3);
            sum += v3[0] + v3[1] + v3[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3back_machine_4\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3back_machine_4", elapsed);
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
        try save_to_file(init, "v3back_locals", elapsed);
    }

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
        try save_to_file(init, "v3back_mut_components", elapsed);
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
