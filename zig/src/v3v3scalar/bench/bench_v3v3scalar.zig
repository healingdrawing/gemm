// bench_v3v3scalar.zig
const std = @import("std");

const Vec3 = @Vector(3, f32);

pub fn main(init: std.process.Init) !void {
    const iterations = 10_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var a: Vec3 = .{ 1, 2, 3 };
    var b: Vec3 = .{ 1, 2, 3 };

    // a = @shuffle(f32, a, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
    // b = @shuffle(f32, b, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });

    std.debug.print("Benchmarking v3v3scalar variants ({} iterations)\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;
    var a0: f32 = undefined;

    inline for (.{ "Return f32", "Out *f32", "Mutate v1" }, 0..) |name, i| {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        if (i == 0) {
            for (0..iterations) |_| {
                a = @shuffle(f32, a, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                b = @shuffle(f32, b, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                sum += dot_return(&a, &b);
            }
        } else if (i == 1) {
            for (0..iterations) |_| {
                a = @shuffle(f32, a, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                b = @shuffle(f32, b, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                dot_out_f32(&a, &b, &result);
                sum += result;
            }
        } else {
            for (0..iterations) |_| {
                a = @shuffle(f32, a, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                b = @shuffle(f32, b, @Vector(3, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 }, @Vector(3, i32){ 0, 1, 2 });
                a0 = a[0];
                dot_mutate(&a, &b);
                sum += a[0];
                a[0] = a0;
            }
        }

        volatile_sum += sum;

        const end = std.Io.Clock.real.now(init.io);
        const duration = start.durationTo(end);
        const elapsed_ns = duration.toNanoseconds();

        std.debug.print("{d}. {s: <20} : {d:>12} ns (sum: {d:.4})\n", .{ i + 1, name, elapsed_ns, sum });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
    std.debug.print("Note: Lower time = better.\n", .{});
}

// slowest
fn dot_return(a: *const Vec3, b: *const Vec3) f32 {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

fn dot_out_f32(a: *const Vec3, b: *const Vec3, result: *f32) void {
    result.* = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

// fastest, tiny bit difference in avarage
fn dot_mutate(a: *Vec3, b: *const Vec3) void {
    a[0] = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}
