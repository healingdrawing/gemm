// bench_vec3_vs_vec4.zig
const std = @import("std");

const Vec3 = @Vector(3, f32);
const Vec4 = @Vector(4, f32);

pub fn main(init: std.process.Init) !void {
    const iterations = 10_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var a3: Vec3 = .{ 1, 2, 3 };
    var b3: Vec3 = .{ 4, 5, 6 };
    var a4: Vec4 = .{ 1, 2, 3, 0 };
    var b4: Vec4 = .{ 4, 5, 6, 0 };

    std.debug.print("Fair benchmark - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    inline for (.{ "Vec3 Unrolled", "Vec3 FMA", "Vec4 SIMD (w=0)", "Vec4 Unrolled" }, 0..) |name, i| {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;

        for (0..iterations) |_| {
            a3 = @shuffle(f32, a3, @Vector(3, f32){ rand.float(f32) * 8 - 4, rand.float(f32) * 8 - 4, rand.float(f32) * 8 - 4 }, @Vector(3, i32){ 0, 1, 2 });
            b3 = @shuffle(f32, b3, @Vector(3, f32){ rand.float(f32) * 8 - 4, rand.float(f32) * 8 - 4, rand.float(f32) * 8 - 4 }, @Vector(3, i32){ 0, 1, 2 });

            a4 = .{ a3[0], a3[1], a3[2], 0 };
            b4 = .{ b3[0], b3[1], b3[2], 0 };

            if (i == 0) dot3_unrolled(&a3, &b3, &result) else if (i == 1) dot3_fma(&a3, &b3, &result) else if (i == 2) dot4_simd(&a4, &b4, &result) else dot4_unrolled(&a4, &b4, &result);

            sum += result;
        }

        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();

        std.debug.print("{d}. {s: <18} : {d:>10} ns  ({d:.3} ns/op)\n", .{ i + 1, name, elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }
}

inline fn dot3_unrolled(a: *const Vec3, b: *const Vec3, r: *f32) void {
    r.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}
inline fn dot3_fma(a: *const Vec3, b: *const Vec3, r: *f32) void {
    r.* = @mulAdd(f32, a[0], b[0], @mulAdd(f32, a[1], b[1], a[2] * b[2]));
}

inline fn dot4_simd(a: *const Vec4, b: *const Vec4, r: *f32) void {
    r.* = @reduce(.Add, a.* * b.*);
}
inline fn dot4_unrolled(a: *const Vec4, b: *const Vec4, r: *f32) void {
    r.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}
