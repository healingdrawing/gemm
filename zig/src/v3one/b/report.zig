const std = @import("std");
const mem = std.mem;

const Entry = struct {
    name: []const u8,
    avg: f64,
    dev: f64,
};

pub fn main(init: std.process.Init) !void {
    const allocator = std.heap.page_allocator;

    const io = init.io;

    const cwd = std.Io.Dir.cwd();
    var dir = try cwd.openDir(io, ".", .{ .iterate = true });
    defer dir.close(io);

    var entries: std.ArrayList(Entry) = .empty;

    var it = dir.iterate();
    while (try it.next(io)) |entry| {
        if (entry.kind != .file) continue;
        if (entry.name.len < 2 or entry.name[0] != '_') continue;

        const name = try allocator.dupe(u8, entry.name[1..]);
        const content = try cwd.readFileAlloc(io, entry.name, allocator, .limited(1024 * 1024));

        var nums: std.ArrayList(f64) = .empty;
        const line = mem.trim(u8, content, " \t\r\n");
        var parts = mem.tokenizeScalar(u8, line, ' ');
        while (parts.next()) |tok| {
            if (tok.len == 0) continue;
            try nums.append(allocator, try std.fmt.parseFloat(f64, tok));
        }
        if (nums.items.len == 0) continue;

        // 1. sort ascending
        const sorted = try allocator.dupe(f64, nums.items);
        defer allocator.free(sorted);
        std.mem.sort(f64, sorted, {}, std.sort.asc(f64));

        // 2. drop the four extreme edges
        const usable = if (sorted.len >= 10) sorted[4 .. sorted.len - 4] else sorted;

        // 3. some way of speed deviation (not very clear results actually)

        // speed average. relative bigger counts number per same time are better
        var sum: f64 = 0;
        for (usable) |v| sum += v;
        const avg = if (usable.len == 0) 0.0 else sum / @as(f64, @floatFromInt(usable.len));

        // deviation
        var sum_sq_diff: f64 = 0;
        for (usable) |v| {
            const diff = v - avg;
            sum_sq_diff += diff * diff;
        }
        const std_dev = @sqrt(sum_sq_diff / @as(f64, @floatFromInt(usable.len)));

        // Calculate coefficient of variation (CV%). nope, will experimenting
        // const dev = (std_dev / avg) * 100;
        const dev = (std_dev / avg);

        try entries.append(allocator, .{
            .name = name,
            .avg = avg,
            .dev = dev,
        });
    }

    if (entries.items.len == 0) {
        std.debug.print("No _* files found in current directory.\n", .{});
        return;
    }

    // SPEED
    {
        const items = try allocator.dupe(Entry, entries.items);
        std.mem.sort(Entry, items, {}, struct {
            fn less(_: void, a: Entry, b: Entry) bool {
                return a.avg > b.avg;
            }
        }.less);

        const etalon = items[0].avg;
        std.debug.print("\n=== SPEED (double-edge trimmed average execution time, higher is better) ===\n\n", .{});
        std.debug.print("{s:<24} | {s:>14} | {s:>10} | {s:>6}\n", .{ "name", "avgspeed", "slower%", "fastest" });
        std.debug.print("{s:-<24}-+-{s:-<14}-+-{s:-<10}-+-{s:-<6}\n", .{ "", "", "", "" });
        for (items, 0..) |e, i| {
            const slower = if (etalon == 0) 0.0 else 100 - (e.avg / etalon) * 100.0;
            std.debug.print("{s:<24} | {d:>14.3} | {d:>9.1}% | {d:>6}\n", .{ e.name, e.avg, slower, i + 1 });
        }
    }

    // STABILITY
    {
        const items = try allocator.dupe(Entry, entries.items);
        std.mem.sort(Entry, items, {}, struct {
            fn less(_: void, a: Entry, b: Entry) bool {
                return a.dev < b.dev;
            }
        }.less);

        const etalon = items[0].dev;
        std.debug.print("\n=== STABILITY (some deviation between runs, lower is better) ===\n\n", .{});
        std.debug.print("{s:<24} | {s:>14} | {s:>10} | {s:>12}\n", .{ "name", "maxtomin", "wider%", "instability" });
        std.debug.print("{s:-<24}-+-{s:-<14}-+-{s:-<10}-+-{s:-<12}\n", .{ "", "", "", "" });
        for (items, 0..) |e, i| {
            const slower = if (etalon == 0) 0.0 else (e.dev / etalon) * 100.0 - 100.0;
            std.debug.print("{s:<24} | {d:>14.3} | {d:>9.1}% | {d:>12}\n", .{ e.name, e.dev, slower, i + 1 });
        }
    }

    // COMBINED (higher avg / lower dev → higher score is better)
    {
        const items = try allocator.dupe(Entry, entries.items);

        std.mem.sort(Entry, items, {}, struct {
            fn less(_: void, a: Entry, b: Entry) bool {
                const score_a = a.avg / a.dev;
                const score_b = b.avg / b.dev;
                return score_a > score_b; // higher score better
            }
        }.less);

        std.debug.print("\n=== COMBINED (avg / dev, higher is better) ===\n\n", .{});
        std.debug.print("{s:<24} | {s:>14} | {s:>12} | {s:>10}\n", .{ "name", "score", "avg", "dev" });
        std.debug.print("{s:-<24}-+-{s:-<14}-+-{s:-<12}-+-{s:-<10}\n", .{ "", "", "", "" });

        for (items, 0..) |e, i| {
            const score = e.avg / e.dev;
            std.debug.print("{s:<24} | {d:>14.1} | {d:>12.0} | {d:>10.5} | #{d}\n", .{ e.name, score, e.avg, e.dev, i + 1 });
        }
    }

    std.debug.print("\n", .{});
}
