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

        var sum: f64 = 0;
        var min_v: f64 = nums.items[0];
        var max_v: f64 = nums.items[0];
        for (nums.items) |v| {
            if (v < min_v) min_v = v;
            if (v > max_v) max_v = v;
        }

        // ignore edge min max to decrease possible mono splash
        var second_min_v = max_v;
        var second_max_v = min_v;
        for (nums.items) |v| {
            if (v < second_min_v and v > min_v) second_min_v = v;
            if (v > second_max_v and v < max_v) second_max_v = v;
        }

        var min_v_found = false;
        var max_v_found = false;

        // ignore egde min and max here also
        for (nums.items) |v| {
            if (v > min_v and v < max_v or (v == min_v and min_v_found) or (v == max_v and max_v_found)) {
                sum += v;
            } else if (v == min_v) {
                min_v_found = true;
            } else if (v == max_v) {
                max_v_found = true;
            }
        }

        try entries.append(allocator, .{
            .name = name,
            .avg = sum / (@as(f64, @floatFromInt(nums.items.len)) - 2), //cut two edges
            .dev = second_max_v - second_min_v,
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
                return a.avg < b.avg;
            }
        }.less);

        const etalon = items[0].avg;
        std.debug.print("\n=== SPEED (edge trimmed average execution time, lower is better) ===\n\n", .{});
        std.debug.print("{s:<24} | {s:>14} | {s:>10} | {s:>6}\n", .{ "name", "average", "slower%", "fastest" });
        std.debug.print("{s:-<24}-+-{s:-<14}-+-{s:-<10}-+-{s:-<6}\n", .{ "", "", "", "" });
        for (items, 0..) |e, i| {
            const slower = if (etalon == 0) 0.0 else (e.avg / etalon) * 100.0 - 100.0;
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
        std.debug.print("\n=== STABILITY (edge trimmed max-min deviation, lower is better) ===\n\n", .{});
        std.debug.print("{s:<24} | {s:>14} | {s:>10} | {s:>12}\n", .{ "name", "maxtomin", "wider%", "instability" });
        std.debug.print("{s:-<24}-+-{s:-<14}-+-{s:-<10}-+-{s:-<12}\n", .{ "", "", "", "" });
        for (items, 0..) |e, i| {
            const slower = if (etalon == 0) 0.0 else (e.dev / etalon) * 100.0 - 100.0;
            std.debug.print("{s:<24} | {d:>14.3} | {d:>9.1}% | {d:>12}\n", .{ e.name, e.dev, slower, i + 1 });
        }
    }

    std.debug.print("\n", .{});
}
