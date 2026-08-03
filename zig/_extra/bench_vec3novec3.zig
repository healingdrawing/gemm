// bench_vec3novec3.zig
const std = @import("std");

// Style 1: Named type
const Vec3 = @Vector(4, f32);

// Style 2: No named type - raw @Vector(4, f32)
const RawVec4 = @Vector(4, f32);

pub fn main(init: std.process.Init) !void {
    const iterations = 15_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var a_named: Vec3 = .{ 1, 2, 3, 0 };
    var b_named: Vec3 = .{ 4, 5, 6, 0 };

    var a_raw: RawVec4 = .{ 1, 2, 3, 0 };
    var b_raw: RawVec4 = .{ 4, 5, 6, 0 };

    std.debug.print("Comparing Named Vec3 vs Raw @Vector(4,f32) - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    // Named type version
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;

        for (0..iterations) |_| {
            a_named = @shuffle(f32, a_named, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b_named = @shuffle(f32, b_named, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });

            v3v3scalar_named(&a_named, &b_named, &result);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("1. Named Vec3       : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // Raw @Vector version
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;

        for (0..iterations) |_| {
            a_raw = @shuffle(f32, a_raw, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b_raw = @shuffle(f32, b_raw, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });

            v3v3scalar_raw(&a_raw, &b_raw, &result);
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("2. Raw @Vector(4,f32): {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}

// === Two styles of the same function ===

inline fn v3v3scalar_named(a: *const Vec3, b: *const Vec3, result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

inline fn v3v3scalar_raw(a: *const @Vector(4, f32), b: *const @Vector(4, f32), result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

// zig run bench_vec3novec3.zig -OReleaseFast
