const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const iterations = 20_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    std.debug.print("Normalization Benchmark - {} iterations\n", .{iterations});
    std.debug.print("Testing @Vector(3, f32) and @Vector(4, f32)\n\n", .{});

    var volatile_sum: f32 = 0;

    // ============ @Vector(3, f32) ============
    std.debug.print("=== @Vector(3, f32) ===\n", .{});

    // 2. SIMD (broadcast /mag) - Vector3
    {
        var v3_simd: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3_simd = @shuffle(f32, v3_simd, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });

            const mag = @sqrt(v3_simd[0] * v3_simd[0] + v3_simd[1] * v3_simd[1] + v3_simd[2] * v3_simd[2]);
            if (mag != 0) {
                const mag_vec: @Vector(3, f32) = .{ mag, mag, mag };
                v3_simd /= mag_vec;
            }
            sum += v3_simd[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  2. SIMD (broadcast /mag)           : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. FMA for dot product - Vector3
    {
        var v3_fma: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3_fma = @shuffle(f32, v3_fma, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });

            var mag_sq = v3_fma[0] * v3_fma[0];
            mag_sq = @mulAdd(f32, v3_fma[1], v3_fma[1], mag_sq);
            mag_sq = @mulAdd(f32, v3_fma[2], v3_fma[2], mag_sq);

            const mag = @sqrt(mag_sq);
            if (mag != 0) {
                const mag_vec: @Vector(3, f32) = .{ mag, mag, mag };
                v3_fma /= mag_vec;
            }
            sum += v3_fma[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  4. FMA for dot product             : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // ============ @Vector(4, f32) ============
    std.debug.print("\n=== @Vector(4, f32) ===\n", .{});

    // 2. SIMD (broadcast /mag) - Vector4
    {
        var v4_simd: @Vector(4, f32) = .{ 3.0, 4.0, 5.0, 0.0 };
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v4_simd = @shuffle(f32, v4_simd, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });

            const mag = @sqrt(v4_simd[0] * v4_simd[0] + v4_simd[1] * v4_simd[1] + v4_simd[2] * v4_simd[2]);
            if (mag != 0) {
                const mag_vec: @Vector(4, f32) = .{ mag, mag, mag, 1.0 };
                v4_simd /= mag_vec;
            }
            sum += v4_simd[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  2. SIMD (broadcast /mag)           : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. FMA for dot product - Vector4
    {
        var v4_fma: @Vector(4, f32) = .{ 3.0, 4.0, 5.0, 0.0 };
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v4_fma = @shuffle(f32, v4_fma, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0.0 }, @Vector(4, i32){ 0, 1, 2, 3 });

            var mag_sq = v4_fma[0] * v4_fma[0];
            mag_sq = @mulAdd(f32, v4_fma[1], v4_fma[1], mag_sq);
            mag_sq = @mulAdd(f32, v4_fma[2], v4_fma[2], mag_sq);

            const mag = @sqrt(mag_sq);
            if (mag != 0) {
                const mag_vec: @Vector(4, f32) = .{ mag, mag, mag, 1.0 };
                v4_fma /= mag_vec;
            }
            sum += v4_fma[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("  4. FMA for dot product             : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
