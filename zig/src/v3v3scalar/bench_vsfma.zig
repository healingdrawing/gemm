const std = @import("std");

// Original: common multiplication and summation - Vector(4, f32)
pub inline fn v3v3scalar_common_v4(a: *const @Vector(4, f32), b: *const @Vector(4, f32), result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

// Refactored: using @mulAdd - Vector(4, f32)
pub inline fn v3v3scalar_fma_v4(a: *const @Vector(4, f32), b: *const @Vector(4, f32), result: *f32) void {
    var acc = a[0] * b[0];
    acc = @mulAdd(f32, a[1], b[1], acc);
    acc = @mulAdd(f32, a[2], b[2], acc);
    result.* = acc;
}

// Original: common multiplication and summation - Vector(3, f32)
pub inline fn v3v3scalar_common_v3(a: *const @Vector(3, f32), b: *const @Vector(3, f32), result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

// Refactored: using @mulAdd - Vector(3, f32) //todo looks like this approach more suitable for free tier docker etc.
pub inline fn v3v3scalar_fma_v3(a: *const @Vector(3, f32), b: *const @Vector(3, f32), result: *f32) void {
    var acc = a[0] * b[0];
    acc = @mulAdd(f32, a[1], b[1], acc);
    acc = @mulAdd(f32, a[2], b[2], acc);
    result.* = acc;
}

pub fn main(init: std.process.Init) !void {
    const iterations = 1_000_000_000; // Increased from 100M to 1B

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    std.debug.print("Dot Product Benchmark - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;

    // ============ Warm-up phase ============
    std.debug.print("Running warm-up phase...\n", .{});
    {
        var a_data: @Vector(4, f32) = .{ 1.0, 2.0, 3.0, 0.0 };
        var b_data: @Vector(4, f32) = .{ 4.0, 5.0, 6.0, 0.0 };
        var result: f32 = 0;
        for (0..100_000_000) |_| {
            a_data = @shuffle(f32, a_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b_data = @shuffle(f32, b_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            v3v3scalar_common_v4(&a_data, &b_data, &result);
            volatile_sum += result;
        }
    }
    std.debug.print("Warm-up complete.\n\n", .{});

    // ============ @Vector(4, f32) ============
    std.debug.print("=== @Vector(4, f32) ===\n", .{});

    // Common: multiplication and summation - V4
    {
        var a_data: @Vector(4, f32) = .{ 1.0, 2.0, 3.0, 0.0 };
        var b_data: @Vector(4, f32) = .{ 4.0, 5.0, 6.0, 0.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b_data = @shuffle(f32, b_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            v3v3scalar_common_v4(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  Common (mul + add)    : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // FMA: @mulAdd - V4
    {
        var a_data: @Vector(4, f32) = .{ 1.0, 2.0, 3.0, 0.0 };
        var b_data: @Vector(4, f32) = .{ 4.0, 5.0, 6.0, 0.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b_data = @shuffle(f32, b_data, @Vector(4, f32){ rand.float(f32), rand.float(f32), rand.float(f32), 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            v3v3scalar_fma_v4(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  FMA (@mulAdd)        : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // ============ @Vector(3, f32) ============
    std.debug.print("\n=== @Vector(3, f32) ===\n", .{});

    // Common: multiplication and summation - V3
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            v3v3scalar_common_v3(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  Common (mul + add)    : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // FMA: @mulAdd - V3
    {
        var a_data: @Vector(3, f32) = .{ 1.0, 2.0, 3.0 };
        var b_data: @Vector(3, f32) = .{ 4.0, 5.0, 6.0 };
        const start = std.Io.Clock.real.now(init.io);
        var result: f32 = 0;
        for (0..iterations) |_| {
            a_data = @shuffle(f32, a_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            b_data = @shuffle(f32, b_data, @Vector(3, f32){ rand.float(f32), rand.float(f32), rand.float(f32) }, @Vector(3, i32){ 0, 1, 2 });
            v3v3scalar_fma_v3(&a_data, &b_data, &result);
            volatile_sum += result;
        }
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  FMA (@mulAdd)        : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
