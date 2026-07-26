// bench_datatype.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const iterations = 20_000_000;

    var rng = std.Random.DefaultPrng.init(42);
    const rand = rng.random();

    var a4v: @Vector(4, f32) = .{ 1, 2, 3, 0 };
    var b4v: @Vector(4, f32) = .{ 4, 5, 6, 0 };

    var a4a: [4]f32 = .{ 1, 2, 3, 0 };
    var b4a: [4]f32 = .{ 4, 5, 6, 0 };

    var a3a: [3]f32 = .{ 1, 2, 3 };
    var b3a: [3]f32 = .{ 4, 5, 6 };

    std.debug.print("Data type only (same calculation) - {} iterations\n\n", .{iterations});

    var volatile_sum: f32 = 0;
    var result: f32 = undefined;

    // 1. @Vector(4, f32)
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            a4v = @shuffle(f32, a4v, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            b4v = @shuffle(f32, b4v, @Vector(4, f32){ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 }, @Vector(4, i32){ 0, 1, 2, 3 });
            result = a4v[0] * b4v[0] + a4v[1] * b4v[1] + a4v[2] * b4v[2];
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("1. @Vector(4,f32) : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 2. [4]f32
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            a4a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 };
            b4a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, 0 };
            result = a4a[0] * b4a[0] + a4a[1] * b4a[1] + a4a[2] * b4a[2];
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("2. [4]f32         : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    // 3. [3]f32
    {
        const start = std.Io.Clock.real.now(init.io);
        var sum: f32 = 0;
        for (0..iterations) |_| {
            a3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            b3a = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
            result = a3a[0] * b3a[0] + a3a[1] * b3a[1] + a3a[2] * b3a[2];
            sum += result;
        }
        volatile_sum += sum;
        const elapsed = start.durationTo(std.Io.Clock.real.now(init.io)).toNanoseconds();
        std.debug.print("3. [3]f32         : {d:>12} ns  ({d:.3} ns/op)\n", .{ elapsed, @as(f64, @floatFromInt(elapsed)) / iterations });
    }

    std.debug.print("\nFinal volatile sum: {d:.4}\n", .{volatile_sum});
}
