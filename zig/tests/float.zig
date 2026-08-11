const std = @import("std");

/// Parse space-separated f32 values into an array
/// Single values are wrapped in array of length 1
pub inline fn parse_float_result(allocator: std.mem.Allocator, output: []const u8) ![]f32 {
    const trimmed = std.mem.trim(u8, output, " \n\r\t");

    var values = try std.ArrayList(f32).initCapacity(allocator, 256);
    defer values.deinit(allocator);

    var parts = std.mem.splitSequence(u8, trimmed, " ");

    while (parts.next()) |part| {
        const clean = std.mem.trim(u8, part, " \t");
        if (clean.len == 0) continue;
        const value = try std.fmt.parseFloat(f32, clean);
        try values.append(allocator, value);
    }
    return try values.toOwnedSlice(allocator);
}

/// Compare two f32 values with epsilon tolerance
/// Treats NaN == NaN as true
/// Treats +Inf == +Inf and -Inf == -Inf as true
pub inline fn floats_equal(a: f32, b: f32, epsilon: f32) bool {
    if (std.math.isNan(a) and std.math.isNan(b)) {
        return true;
    }
    if (std.math.isNan(a) or std.math.isNan(b)) {
        return false;
    }
    // Infinity must have the same sign to be equal
    if (std.math.isInf(a) or std.math.isInf(b)) {
        return a == b; // +Inf == +Inf, -Inf == -Inf, but +Inf != -Inf
    }
    return @abs(a - b) <= epsilon;
}

/// Compare two f32 arrays with epsilon tolerance
pub inline fn arrays_equal(a: []const f32, b: []const f32, epsilon: f32) !bool {
    if (a.len != b.len) {
        std.debug.print("\nlength mismatch: {d} vs {d}\na={any}\nb={any}\n", .{ a.len, b.len, a, b });
        return false;
    }

    for (0..a.len) |i| {
        if (!floats_equal(a[i], b[i], epsilon)) {
            std.debug.print("  [{d}] mismatch: {any} vs {any}\n", .{ i, a[i], b[i] });
            return false;
        }
    }
    return true;
}

/// Convert any numeric type or vector to f32 array
/// Scalars are packed as [1]f32, vectors/arrays are converted to []f32
pub inline fn to_array(allocator: std.mem.Allocator, value: anytype) ![]f32 {
    const T = @TypeOf(value);
    const type_info = @typeInfo(T);

    return switch (type_info) {
        .float => blk: {
            const arr = try allocator.alloc(f32, 1);
            arr[0] = @floatCast(value);
            break :blk arr;
        },
        .vector => |vec_info| blk: {
            const arr = try allocator.alloc(f32, vec_info.len);
            inline for (0..vec_info.len) |i| {
                arr[i] = @floatCast(value[i]);
            }
            break :blk arr;
        },
        .pointer => |ptr_info| blk: {
            if (ptr_info.size == .slice or ptr_info.size == .many) {
                // Already a slice/array—just cast if needed
                if (ptr_info.child == f32) {
                    break :blk value;
                } else {
                    const arr = try allocator.alloc(f32, value.len);
                    for (0..value.len) |i| {
                        arr[i] = @floatCast(value[i]);
                    }
                    break :blk arr;
                }
            } else {
                @compileError("Unsupported pointer type");
            }
        },
        .array => |arr_info| blk: {
            const arr = try allocator.alloc(f32, arr_info.len);
            inline for (0..arr_info.len) |i| {
                arr[i] = @floatCast(value[i]);
            }
            break :blk arr;
        },
        else => @compileError("Unsupported type for to_array"),
    };
}

pub fn vectors_to_string(allocator: std.mem.Allocator, inputs: anytype) ![]u8 {
    var result = try std.ArrayList(u8).initCapacity(allocator, 256);
    defer result.deinit(allocator);

    inline for (inputs, 0..) |item, idx| {
        if (idx > 0) try result.appendSlice(allocator, " ");

        const T = @TypeOf(item);
        const type_info = @typeInfo(T);

        if (type_info == .vector) {
            const len = type_info.vector.len;
            inline for (0..len) |i| {
                if (i > 0) try result.appendSlice(allocator, " ");
                const val = item[i];
                try append_float_string(allocator, &result, val);
            }
        } else if (type_info == .array) {
            const len = type_info.array.len;
            inline for (0..len) |i| {
                if (i > 0) try result.appendSlice(allocator, " ");
                const val = item[i];
                try append_float_string(allocator, &result, val);
            }
        } else if (type_info == .float or type_info == .int) {
            const val = item;
            try append_float_string(allocator, &result, val);
        }
    }

    return result.toOwnedSlice(allocator);
}

fn append_float_string(allocator: std.mem.Allocator, result: *std.ArrayList(u8), val: f32) !void {
    if (std.math.isNan(val)) {
        try result.appendSlice(allocator, "NaN");
    } else if (std.math.isInf(val)) {
        if (val > 0) {
            try result.appendSlice(allocator, "Infinity");
        } else {
            try result.appendSlice(allocator, "-Infinity");
        }
    } else {
        var buf: [64]u8 = undefined; //warning input length affects buf size 64 vs 32
        const str = try std.fmt.bufPrint(&buf, "{d}", .{val});
        try result.appendSlice(allocator, str);
    }
}
