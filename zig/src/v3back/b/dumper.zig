const std = @import("std");

pub fn save_to_file(init: std.process.Init, file_name: []const u8, elapsed_ns: i96) !void {
    var file_data_buf: [256]u8 = undefined;
    const file_data = try std.fmt.bufPrint(&file_data_buf, "{d} ", .{elapsed_ns});

    const the_io = init.io;

    const allocator = std.heap.page_allocator;
    const final_name = try std.fmt.allocPrint(allocator, "_{s}", .{file_name});
    defer allocator.free(final_name);

    var file = try std.Io.Dir.createFile(std.Io.Dir.cwd(), the_io, final_name, .{ .truncate = false });
    defer file.close(the_io);

    const stat = try file.stat(the_io);

    try file.writePositionalAll(the_io, file_data, stat.size);
}
