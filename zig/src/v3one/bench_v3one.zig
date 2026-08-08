// bench_one.zig
const std = @import("std");
const v3one = @import("v3one.zig");
const save_to_file = @import("b/dumper.zig").save_to_file;

const time = std.Io.Clock.real;
const full_ms = 500; // 2000 = 2 seconds per variant

pub fn main(init: std.process.Init) !void {
    std.debug.print("v3one normalization - throughput benchmark ({} ms per variant)\n\n", .{full_ms});

    // try init.io.sleep(.fromMilliseconds(1000), .awake);

    // Helper function to benchmark one variant
    const benchmark = struct {
        /// return case
        fn run(
            init_arg: std.process.Init,
            comptime func_name: []const u8,
            comptime func_ptr: fn (@Vector(3, f32)) callconv(.@"inline") @Vector(3, f32),
        ) !f32 {
            const io = init_arg.io;
            var rng = std.Random.DefaultPrng.init(42);
            const rand = rng.random();

            var v3: @Vector(3, f32) = .{ 1, 2, 3 };
            var result: @Vector(3, f32) = undefined;
            var sum: f32 = 0;

            // Warmup
            const warmup_start = time.now(io);
            while (warmup_start.durationTo(time.now(io)).toMilliseconds() < 500) {
                v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
                result = func_ptr(v3);
                sum += result[0] + result[1] + result[2];
            }

            // Actual benchmark
            const bench_start = time.now(io);
            var count: u64 = 0;

            while (bench_start.durationTo(time.now(io)).toMilliseconds() < full_ms) {
                v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
                result = func_ptr(v3);
                sum += result[0] + result[1] + result[2];
                count += 1;
            }

            const ns_time = @as(f64, @floatFromInt(full_ms * 1_000_000)) / (@as(f64, @floatFromInt(count)));

            std.debug.print("{d:>15.0} ns/time  ({d:>8.2} times) {s}\n", .{ ns_time, count, func_name });
            try save_to_file(init_arg, func_name, @as(i96, count));

            return sum;
        }

        /// mutate case
        // ----- in-place (pointer) versions -----
        fn runInPlace(
            init_arg: std.process.Init,
            comptime func_name: []const u8,
            comptime func_ptr: fn (*@Vector(3, f32)) callconv(.@"inline") void,
        ) !f32 {
            const io = init_arg.io;
            var rng = std.Random.DefaultPrng.init(42);
            const rand = rng.random();

            var v3: @Vector(3, f32) = .{ 1, 2, 3 };
            var sum: f32 = 0;

            // Warmup
            const warmup_start = time.now(io);
            while (warmup_start.durationTo(time.now(io)).toMilliseconds() < 500) {
                v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
                func_ptr(&v3);
                sum += v3[0] + v3[1] + v3[2];
            }

            // Actual benchmark
            const bench_start = time.now(io);
            var count: u64 = 0;

            while (bench_start.durationTo(time.now(io)).toMilliseconds() < full_ms) {
                v3 = .{ rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5, rand.float(f32) * 10 - 5 };
                func_ptr(&v3);
                sum += v3[0] + v3[1] + v3[2];
                count += 1;
            }

            const ns_time = @as(f64, @floatFromInt(full_ms * 1_000_000)) / (@as(f64, @floatFromInt(count)));

            std.debug.print("{d:>15.0} ns/time  ({d:>8.2} times) {s}\n", .{ ns_time, count, func_name });
            try save_to_file(init_arg, func_name, @as(i96, count));

            return sum;
        }
    };

    // Benchmark each variant
    _ = try benchmark.run(init, "v3one_machine_1", v3one.v3one_machine_1);
    _ = try benchmark.run(init, "v3one_machine_2", v3one.v3one_machine_2);
    _ = try benchmark.run(init, "v3one_machine_3", v3one.v3one_machine_3);
    _ = try benchmark.run(init, "v3one_machine_4", v3one.v3one_machine_4);
    _ = try benchmark.run(init, "v3one_machine_5", v3one.v3one_machine_5);
    _ = try benchmark.run(init, "v3one_machine_6", v3one.v3one_machine_6);
    _ = try benchmark.run(init, "v3one_machine_7", v3one.v3one_machine_7);
    _ = try benchmark.run(init, "v3one_std_1", v3one.v3one_std_1);
    _ = try benchmark.run(init, "v3one_std_2", v3one.v3one_std_2);
    _ = try benchmark.run(init, "v3one_std_3", v3one.v3one_std_3);

    _ = try benchmark.runInPlace(init, "v3one_machine_8", v3one.v3one_machine_8);
    _ = try benchmark.runInPlace(init, "v3one_std_4", v3one.v3one_std_4);
}
