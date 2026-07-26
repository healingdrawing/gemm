const std = @import("std");

pub inline fn v3v3scalar_fma_v3_noptr(a: @Vector(3, f32), b: @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
}

pub inline fn v3v3scalar_fma_v3_ptr(a: *const @Vector(3, f32), b: *const @Vector(3, f32)) f32 {
    return @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
}

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    std.debug.print("Dot Product Benchmark - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;

    std.debug.print("Running warm-up phase...\n", .{});
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        for (0..100_000_000) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            volatile_sum += v3v3scalar_fma_v3_noptr(a_data, b_data);
        }
    }
    std.debug.print("Warm-up complete.\n\n", .{});

    std.debug.print("=== @Vector(3, f32) FMA ===\n", .{});

    // No pointers
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            volatile_sum += v3v3scalar_fma_v3_noptr(a_data, b_data);
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  No pointers           : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // Pointers
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            volatile_sum += v3v3scalar_fma_v3_ptr(&a_data, &b_data);
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  Pointers              : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
