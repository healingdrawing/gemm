// zig/src/v3v3scalar/cli_v3v3scalar.zig
const std = @import("std");
const v3v3scalar = @import("v3v3scalar.zig").v3v3scalar;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 7) {
        std.debug.print("Usage: cli_v3v3scalar <ax> <ay> <az> <bx> <by> <bz>\n", .{});
        std.debug.print("Example: cli_v3v3scalar 1 2 3 4 5 6\n", .{});
        return;
    }

    var v3a: [3]f32 = undefined;
    var v3b: [3]f32 = undefined;
    var result: f32 = undefined;

    for (0..3) |i| {
        v3a[i] = std.fmt.parseFloat(f32, args[i + 1]) catch {
            std.debug.print("Error parsing argument {d}\n", .{i + 1});
            result = std.math.nan(f32);
            break;
        };
        v3b[i] = std.fmt.parseFloat(f32, args[i + 4]) catch {
            std.debug.print("Error parsing argument {d}\n", .{i + 4});
            result = std.math.nan(f32);
            break;
        };
    }

    if (result != std.math.nan(f32)) result = v3v3scalar(v3a, v3b);

    // Use debug.print to avoid any io issues
    // std.debug.print("{d:.12}\n", .{result}); // this looks like prints in errlog. Writes to stderr, ignoring errors.
    var buffer: [64]u8 = undefined;
    const formatted = try std.fmt.bufPrint(&buffer, "{d:.12}\n", .{result});

    try std.Io.File.stdout().writeStreamingAll(init.io, formatted);
    // it is so ugly... just to print number into terminal output, facepalm. Let is hope later API will be not so ... supreme
}
