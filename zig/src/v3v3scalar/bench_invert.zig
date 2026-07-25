const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const iterations = 20_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var v3_store_mag_sq: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };
    var v3_simd: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };
    var v3_simd_no_check: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };
    var v3_fma: @Vector(3, f32) = .{ 3.0, 4.0, 5.0 };

    std.debug.print("Normalization Benchmark - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;

    // 1. Store mag_sq first
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3_store_mag_sq = @shuffle(f32, v3_store_mag_sq, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });

            const mag_sq = v3_store_mag_sq[0] * v3_store_mag_sq[0] + v3_store_mag_sq[1] * v3_store_mag_sq[1] + v3_store_mag_sq[2] * v3_store_mag_sq[2];
            const mag = @sqrt(mag_sq);
            if (mag != 0) {
                const mag_vec: @Vector(3, f32) = .{ mag, mag, mag };
                v3_store_mag_sq /= mag_vec;
            }
            sum += v3_store_mag_sq[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("1. Store mag_sq first              : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. SIMD (broadcast /mag)
    {
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
        std.debug.print("2. SIMD (broadcast /mag)           : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. SIMD (no check /mag)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            v3_simd_no_check = @shuffle(f32, v3_simd_no_check, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });

            const mag = @sqrt(v3_simd_no_check[0] * v3_simd_no_check[0] + v3_simd_no_check[1] * v3_simd_no_check[1] + v3_simd_no_check[2] * v3_simd_no_check[2]);
            const mag_vec: @Vector(3, f32) = .{ mag, mag, mag };
            v3_simd_no_check /= mag_vec;

            sum += v3_simd_no_check[0];
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("3. SIMD (no check /mag)            : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 4. FMA for dot product . looks like the fastest from tested //todo maybe next bench this vs @Vector(4, f32) variations
    {
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
        std.debug.print("4. FMA for dot product             : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
