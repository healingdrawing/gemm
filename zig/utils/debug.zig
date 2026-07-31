const std = @import("std");
const builtin = @import("builtin");
const posix = std.posix;

/// Controlled by environment variables DEVLOG / ERRLOG ("true" enables).
pub var enable_dev: bool = false;
pub var enable_err: bool = true;

/// Call from main with the environment map from process.Init.
pub fn init_from_env_map(map: *const std.process.Environ.Map) void {
    if (map.get("DEVLOG")) |v| enable_dev = std.mem.eql(u8, v, "true");
    if (map.get("ERRLOG")) |v| enable_err = std.mem.eql(u8, v, "true");
}

/// x16 terminal color pointers for debug.rawlog method
pub const Tcolor = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    bright_black,
    bright_red,
    bright_green,
    bright_yellow,
    bright_blue,
    bright_magenta,
    bright_cyan,
    bright_white,
};

/// Magenta framed error log.  ERRLOG env var dependent.
/// Each argument becomes its own framed row (exactly like the TS version).
/// Usage: errlog(.{"msg", value, err})
pub fn errlog(args: anytype) void {
    if (!enable_err) return;
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("errlog expects a tuple: errlog(.{\"a\", 1, true})");
    }
    if (comptime args.len == 0) return;

    const framed = dprint(true, args) catch return;
    defer std.heap.page_allocator.free(framed);
    std.debug.print("\x1b[35m{s}\x1b[0m\n", .{framed});
}

/// Yellow framed development log. DEVLOG env var dependent.
/// Each argument becomes its own framed row.
pub fn devlog(args: anytype) void {
    if (!enable_dev) return;
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("devlog expects a tuple: devlog(.{\"a\", 1, true})");
    }
    if (comptime args.len == 0) return;

    const framed = dprint(true, args) catch return;
    defer std.heap.page_allocator.free(framed);
    std.debug.print("\x1b[33m{s}\x1b[0m\n", .{framed});
}

/// Slow colored plain log (no frame). Requires "const Tcolor = dp.Tcolor;" first
pub fn rawlog(args: anytype, paintto: Tcolor) void {
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("rawlog expects a tuple: rawlog(.{\"a\", 1})");
    }
    if (comptime args.len == 0) return;

    const msg = join_args(args) catch return;
    defer std.heap.page_allocator.free(msg);

    _ = switch (paintto) {
        .black => std.debug.print("\x1b[30m{s}\x1b[0m\n", .{msg}),
        .red => std.debug.print("\x1b[31m{s}\x1b[0m\n", .{msg}),
        .green => std.debug.print("\x1b[32m{s}\x1b[0m\n", .{msg}),
        .yellow => std.debug.print("\x1b[33m{s}\x1b[0m\n", .{msg}),
        .blue => std.debug.print("\x1b[34m{s}\x1b[0m\n", .{msg}),
        .magenta => std.debug.print("\x1b[35m{s}\x1b[0m\n", .{msg}),
        .cyan => std.debug.print("\x1b[36m{s}\x1b[0m\n", .{msg}),
        .white => std.debug.print("\x1b[37m{s}\x1b[0m\n", .{msg}),
        .bright_black => std.debug.print("\x1b[90m{s}\x1b[0m\n", .{msg}),
        .bright_red => std.debug.print("\x1b[91m{s}\x1b[0m\n", .{msg}),
        .bright_green => std.debug.print("\x1b[92m{s}\x1b[0m\n", .{msg}),
        .bright_yellow => std.debug.print("\x1b[93m{s}\x1b[0m\n", .{msg}),
        .bright_blue => std.debug.print("\x1b[94m{s}\x1b[0m\n", .{msg}),
        .bright_magenta => std.debug.print("\x1b[95m{s}\x1b[0m\n", .{msg}),
        .bright_cyan => std.debug.print("\x1b[96m{s}\x1b[0m\n", .{msg}),
        .bright_white => std.debug.print("\x1b[97m{s}\x1b[0m\n", .{msg}),
    };
}

/// Yellow plain log (no frame). DEVLOG env var dependent.
pub fn rawdevlog(args: anytype) void {
    if (!enable_dev) return;
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("rawlog expects a tuple: rawlog(.{\"a\", 1})");
    }
    if (comptime args.len == 0) return;

    const msg = join_args(args) catch return;
    defer std.heap.page_allocator.free(msg);
    std.debug.print("\x1b[33m{s}\x1b[0m\n", .{msg});
}

/// Magenta plain log (no frame).  ERRLOG env var dependent.
pub fn rawerrlog(args: anytype) void {
    if (!enable_err) return;
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("rawlog expects a tuple: rawlog(.{\"a\", 1})");
    }
    if (comptime args.len == 0) return;

    const msg = join_args(args) catch return;
    defer std.heap.page_allocator.free(msg);
    std.debug.print("\x1b[35m{s}\x1b[0m\n", .{msg});
}

/// Always-on framed log (no color gate).
/// Each argument becomes its own framed row.
pub fn dlog(with_timestamp: bool, args: anytype) void {
    if (comptime @typeInfo(@TypeOf(args)) != .@"struct") {
        @compileError("dlog expects a tuple: dlog(true, .{\"a\", 1})");
    }
    if (comptime args.len == 0) return;

    const framed = dprint(with_timestamp, args) catch return;
    defer std.heap.page_allocator.free(framed);
    std.debug.print("{s}\n", .{framed});
}

// ---------------------------------------------------------------------------
// Core framing – one frame per value (matches original TypeScript dprint)
// ---------------------------------------------------------------------------

fn dprint(with_timestamp: bool, args: anytype) ![]u8 {
    const allocator = std.heap.page_allocator;

    // Collect string representations of every value (timestamp first if requested)
    var value_strs: std.ArrayList([]const u8) = .empty;
    defer {
        for (value_strs.items) |s| allocator.free(s);
        value_strs.deinit(allocator);
    }

    if (with_timestamp) {
        try value_strs.append(allocator, try make_timestamp(allocator));
    }

    inline for (args) |v| {
        try value_strs.append(allocator, try value_to_string(allocator, v));
    }

    const term_w = get_terminal_width();

    // For each value compute its lines + visible width
    var max_w: usize = 0;
    var all_lines: std.ArrayList([][]const u8) = .empty;
    defer {
        for (all_lines.items) |ls| {
            for (ls) |l| allocator.free(l);
            allocator.free(ls);
        }
        all_lines.deinit(allocator);
    }

    for (value_strs.items) |v| {
        const cleaned = try strip_ansi(allocator, v);
        defer allocator.free(cleaned);

        const clean_lines = try split_lines(allocator, cleaned);
        defer {
            for (clean_lines) |l| allocator.free(l);
            allocator.free(clean_lines);
        }

        var visible_max: usize = 0;
        for (clean_lines) |p| visible_max = @max(visible_max, p.len);
        max_w = @max(max_w, visible_max + 4);

        // keep original (with ANSI) for display
        const orig_lines = try split_lines(allocator, v);
        try all_lines.append(allocator, orig_lines);
    }

    var huge = false;
    if (max_w > term_w) {
        huge = true;
        max_w = term_w;
    }

    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(allocator);

    const frame = try allocator.alloc(u8, max_w);
    defer allocator.free(frame);
    @memset(frame, '=');

    try out.append(allocator, '\n');
    if (all_lines.items.len > 0) {
        try out.appendSlice(allocator, frame);
        try out.append(allocator, '\n');
    }

    // Each value gets its own block, then a frame line (exactly like TS)
    for (all_lines.items) |sx| {
        for (sx) |one| {
            if (!huge) {
                const centered = try center_inside(allocator, one, max_w);
                defer allocator.free(centered);
                try out.appendSlice(allocator, centered);
            } else {
                try out.appendSlice(allocator, one);
            }
            try out.append(allocator, '\n');
        }
        try out.appendSlice(allocator, frame);
        try out.append(allocator, '\n');
    }

    // trim trailing newline
    while (out.items.len > 0 and out.items[out.items.len - 1] == '\n') {
        _ = out.pop();
    }

    return try out.toOwnedSlice(allocator);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn value_to_string(allocator: std.mem.Allocator, value: anytype) ![]u8 {
    const T = @TypeOf(value);
    const info = @typeInfo(T);

    if (info == .optional) {
        if (value) |v| return value_to_string(allocator, v);
        return try allocator.dupe(u8, "null");
    }

    if (info == .pointer) {
        const ptr = info.pointer;
        if (ptr.size == .slice and ptr.child == u8) {
            return try allocator.dupe(u8, value);
        }
        if (ptr.size == .one) {
            return value_to_string(allocator, value.*);
        }
    }
    if (info == .array and info.array.child == u8) {
        return try allocator.dupe(u8, &value);
    }

    // fallback
    return try std.fmt.allocPrint(allocator, "{any}", .{value});
}

fn join_args(args: anytype) ![]u8 {
    const allocator = std.heap.page_allocator;
    var list: std.ArrayList(u8) = .empty;
    errdefer list.deinit(allocator);

    inline for (args, 0..) |v, i| {
        if (i > 0) try list.appendSlice(allocator, " ");
        const s = try value_to_string(allocator, v);
        defer allocator.free(s);
        try list.appendSlice(allocator, s);
    }
    return try list.toOwnedSlice(allocator);
}

fn make_timestamp(allocator: std.mem.Allocator) ![]u8 {
    var threaded: std.Io.Threaded = .init_single_threaded;
    defer threaded.deinit();
    const io = threaded.io();

    const ts = std.Io.Clock.real.now(io);
    const secs: u64 = @intCast(@max(ts.toSeconds(), 0));

    const epoch_sec = std.time.epoch.EpochSeconds{ .secs = secs };
    const day = epoch_sec.getEpochDay();
    const year_day = day.calculateYearDay();
    const month_day = year_day.calculateMonthDay();
    const day_sec = epoch_sec.getDaySeconds();

    const month_names = [_][]const u8{
        "",     "January", "February",  "March",   "April",    "May",      "June",
        "July", "August",  "September", "October", "November", "December",
    };

    return std.fmt.allocPrint(allocator, "{d} {s} {d} UTC {d:0>2}:{d:0>2}:{d:0>2}", .{
        month_day.day_index + 1,
        month_names[@intFromEnum(month_day.month)],
        year_day.year,
        day_sec.getHoursIntoDay(),
        day_sec.getMinutesIntoHour(),
        day_sec.getSecondsIntoMinute(),
    });
}

fn get_terminal_width() usize {
    if (builtin.os.tag == .windows) return 80;
    var ws: posix.winsize = undefined;
    const rc = posix.system.ioctl(posix.STDOUT_FILENO, posix.T.IOCGWINSZ, @intFromPtr(&ws));
    if (posix.errno(rc) == .SUCCESS and ws.col > 0) return ws.col;
    return 80;
}

fn strip_ansi(allocator: std.mem.Allocator, s: []const u8) ![]u8 {
    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(allocator);

    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == 0x1b and i + 1 < s.len and s[i + 1] == '[') {
            i += 2;
            while (i < s.len and s[i] != 'm') : (i += 1) {}
            if (i < s.len) i += 1;
            continue;
        }
        try out.append(allocator, s[i]);
        i += 1;
    }
    return try out.toOwnedSlice(allocator);
}

fn split_lines(allocator: std.mem.Allocator, s: []const u8) ![][]const u8 {
    var list: std.ArrayList([]const u8) = .empty;
    errdefer {
        for (list.items) |l| allocator.free(l);
        list.deinit(allocator);
    }

    var start: usize = 0;
    for (s, 0..) |c, i| {
        if (c == '\n') {
            try list.append(allocator, try allocator.dupe(u8, s[start..i]));
            start = i + 1;
        }
    }
    try list.append(allocator, try allocator.dupe(u8, s[start..]));
    return try list.toOwnedSlice(allocator);
}

fn center_inside(allocator: std.mem.Allocator, s: []const u8, max_width: usize) ![]u8 {
    const clean = try strip_ansi(allocator, s);
    defer allocator.free(clean);

    const content_w = clean.len;
    if (max_width < 4 + content_w) {
        return try allocator.dupe(u8, s);
    }
    const pad = max_width - 4 - content_w;
    const left = pad / 2;
    const right = pad - left;

    var out: std.ArrayList(u8) = .empty;
    errdefer out.deinit(allocator);

    try out.appendSlice(allocator, "= ");
    try out.appendNTimes(allocator, ' ', left);
    try out.appendSlice(allocator, s);
    try out.appendNTimes(allocator, ' ', right);
    try out.appendSlice(allocator, " =");
    return try out.toOwnedSlice(allocator);
}
