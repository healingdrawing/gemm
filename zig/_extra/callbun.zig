// zig/src/v3v3scalar/callbun.zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // from zig/src/v3v3scalar/ → ../../../ts/tests/v3v3scalar.test.ts
    const argv = [_][]const u8{
        "bun",
        "test",
        "../../ts/tests/v3v3scalar.test.ts",
    };

    var child = try std.process.spawn(init.io, .{
        .argv = &argv,
        .stdin = .inherit,
        .stdout = .inherit,
        .stderr = .inherit,
    });

    const term = try child.wait(init.io);
    switch (term) {
        .exited => |code| if (code != 0) std.debug.print("bun exited with {d}\n", .{code}),
        else => std.debug.print("bun terminated: {any}\n", .{term}),
    }
}
