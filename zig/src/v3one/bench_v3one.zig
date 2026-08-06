// bench_one.zig
const std = @import("std");
const v3one = @import("v3one.zig");
const save_to_file = @import("b/dumper.zig").save_to_file;

pub fn main(init: std.process.Init) !void {
    const iterations = 100_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3: @Vector(3, f32) = .{ 1, 2, 3 };

    std.debug.print("v3one normalization - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: @Vector(3, f32) = undefined;

    // --- warmup (unmeasured) ---
    {
        var sum: f32 = 0;
        for (0..2_000_000) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            // call whatever variants are currently active in your bench file
            result = v3one.v3one_machine_1(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_2(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_3(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_4(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_5(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_6(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_7(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_machine_8(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_std_1(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_std_2(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_std_3(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_std_4(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
    }

    // machine_1
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_1(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_1\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_1", elapsed);
    }

    // machine_2
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_2(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_2\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_2", elapsed);
    }

    // machine_3
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_3(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_3\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_3", elapsed);
    }

    // machine_4
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_4(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_4\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_4", elapsed);
    }

    // machine_5
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_5(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_5\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_5", elapsed);
    }

    // machine_6
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_6(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_6\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_6", elapsed);
    }

    // machine_7
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_7(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_7\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_7", elapsed);
    }

    // machine_8
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_machine_8(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_machine_8\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_machine_8", elapsed);
    }

    //todo remove later comment. -- old versions

    // std_1
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_std_1(v3);
            sum += result[0] + result[1] + result[2];
            result = v3one.v3one_std_4(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_std_1\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_std_1", elapsed);
    }

    // std_2
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_std_2(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_std_2\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_std_2", elapsed);
    }

    // 3. sequent (step by step)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_std_3(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_std_3\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_std_3", elapsed);
    }

    // 4. sequent (solid mag)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = v3one.v3one_std_4(v3);
            sum += result[0] + result[1] + result[2];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("{d:>12} ns  ({d:.3} ns/op) v3one_std_4\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
        try save_to_file(init, "v3one_std_4", elapsed);
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
