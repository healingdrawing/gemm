const std = @import("std");

pub inline fn v3v3scalar_fma_v3_seq(a: *const @Vector(3, f32), b: *const @Vector(3, f32), result: *f32) void {
    var acc = a[0] * b[0];
    acc = @mulAdd(f32, a[1], b[1], acc);
    acc = @mulAdd(f32, a[2], b[2], acc);
    result.* = acc;
}

pub inline fn v3v3scalar_fma_v3_nested(a: *const @Vector(3, f32), b: *const @Vector(3, f32), result: *f32) void {
    result.* = @mulAdd(f32, a[2], b[2], @mulAdd(f32, a[1], b[1], @mulAdd(f32, a[0], b[0], 0)));
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
        var result: f32 = 0;
        for (0..100_000_000) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            v3v3scalar_fma_v3_seq(&a_data, &b_data, &result);
            volatile_sum += result;
        }
    }
    std.debug.print("Warm-up complete.\n\n", .{});

    std.debug.print("=== @Vector(3, f32) FMA ===\n", .{});

    // Sequential
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            v3v3scalar_fma_v3_seq(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  Sequential            : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // Nested
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            v3v3scalar_fma_v3_nested(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  Nested                : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}

//todo finally looks like nested mulAdd is tiny bit slower then sequenced,  under noise from turned on in tray browser on desktop, but nested in same time more stable , the deviation between benchs are less. So nested should be used for highly noise docker free tier environemnt, to avoid surprises. or i miss something, also AI made analyze of the outputs, so it sounds suitable at the moment
