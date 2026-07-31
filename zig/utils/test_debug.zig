// execute demo: zig run test_debug.zig
// execute + mute devlog: DEVLOG=false ERRLOG=true zig run test_debug.zig
const std = @import("std");
const debug = @import("debug.zig");

pub fn main(init: std.process.Init) !void {
    // demo force both flags on
    debug.enable_dev = true;
    debug.enable_err = true;
    // not nice, but at the moment found only this solution for flags:
    debug.init_from_env_map(init.environ_map);

    debug.rawlog(.{"=== debug.zig demo (Zig 0.16) ===\n\n"}, debug.Tcolor.white);

    // plain yellow, no frame
    debug.rawdevlog(.{"This is a raw yellow log (no frame)"});

    // framed yellow development log
    debug.devlog(.{ "Hello from", "devlog", "- framed yellow development log" });

    // framed magenta error log
    debug.errlog(.{ "Something went wrong:", "connection refused", 503 });

    // always-on framed log WITH optional timestamp
    debug.dlog(true, .{
        "Always-on framed message with timestamp",
        "second value on same call",
    });

    // always-on framed log WITHOUT optional timestamp
    debug.dlog(false, .{"Framed message without timestamp"});

    // mixed types + optional
    const maybe_null: ?i32 = null;
    const maybe_val: ?i32 = 42;
    debug.devlog(.{ "Player", 7, "score", 9001, "optional null _", maybe_null, "optional value _", maybe_val });

    // multi-line + embedded ANSI color
    debug.devlog(.{"Line one\nLine two with \x1b[31mred\x1b[0m text"});

    // just one value
    debug.errlog(.{"single string error"});

    // just one long value , must break the side frame borders
    debug.errlog(.{"single string error, but very long text so it force the side frames to disappear"});

    // numbers, bool, float
    debug.devlog(.{ "numbers:", 1, 2.5, true, false });

    debug.rawlog(.{"\n=== black ===\n"}, debug.Tcolor.black);
    debug.rawlog(.{"\n=== red ===\n"}, debug.Tcolor.red);
    debug.rawlog(.{"\n=== green ===\n"}, debug.Tcolor.green);
    debug.rawlog(.{"\n=== yellow ===\n"}, debug.Tcolor.yellow);
    debug.rawlog(.{"\n=== blue ===\n"}, debug.Tcolor.blue);
    debug.rawlog(.{"\n=== magenta ===\n"}, debug.Tcolor.magenta);
    debug.rawlog(.{"\n=== cyan ===\n"}, debug.Tcolor.cyan);
    debug.rawlog(.{"\n=== white ===\n"}, debug.Tcolor.white);
    debug.rawlog(.{"\n=== bright_black ===\n"}, debug.Tcolor.bright_black);
    debug.rawlog(.{"\n=== bright_red ===\n"}, debug.Tcolor.bright_red);
    debug.rawlog(.{"\n=== bright_green ===\n"}, debug.Tcolor.bright_green);
    debug.rawlog(.{"\n=== bright_yellow ===\n"}, debug.Tcolor.bright_yellow);
    debug.rawlog(.{"\n=== bright_blue ===\n"}, debug.Tcolor.bright_blue);
    debug.rawlog(.{"\n=== bright_magenta ===\n"}, debug.Tcolor.bright_magenta);
    debug.rawlog(.{"\n=== bright_cyan ===\n"}, debug.Tcolor.bright_cyan);
    debug.rawlog(.{"\n=== bright_white ===\n"}, debug.Tcolor.bright_white);

    debug.rawlog(.{"\n=== end of demo ===\n"}, debug.Tcolor.white);
}
