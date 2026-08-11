const std = @import("std");

pub fn main() void {
    const inf = std.math.inf(f32);
    const nan = std.math.nan(f32);
    const zero = @as(f32, 0.0);
    const neg_zero = @as(f32, -0.0);
    const one = @as(f32, 1.0);
    const neg_one = @as(f32, -1.0);

    std.debug.print("\n=== NaN Generation Tests ===\n\n", .{});

    // Division cases
    std.debug.print("--- Division ---\n", .{});
    printOp("inf / inf", inf, inf, inf / inf);
    printOp("-inf / -inf", -inf, -inf, (-inf) / (-inf));
    printOp("inf / -inf", inf, -inf, inf / (-inf));
    printOp("-inf / inf", -inf, inf, (-inf) / inf);
    printOp("0 / 0", zero, zero, zero / zero);
    printOp("-0 / -0", neg_zero, neg_zero, neg_zero / neg_zero);
    printOp("0 / -0", zero, neg_zero, zero / neg_zero);

    std.debug.print("\n--- Square Root ---\n", .{});
    printOp1("sqrt(inf)", inf, @sqrt(inf));
    printOp1("sqrt(-inf)", -inf, @sqrt(-inf));
    printOp1("sqrt(-1)", neg_one, @sqrt(neg_one));

    std.debug.print("\n--- Multiplication ---\n", .{});
    printOp("inf * 0", inf, zero, inf * zero);
    printOp("-inf * 0", -inf, zero, (-inf) * zero);
    printOp("inf * -0", inf, neg_zero, inf * neg_zero);
    printOp("-inf * -0", -inf, neg_zero, (-inf) * neg_zero);

    std.debug.print("\n--- Addition/Subtraction ---\n", .{});
    printOp("inf + (-inf)", inf, -inf, inf + (-inf));
    printOp("-inf + inf", -inf, inf, (-inf) + inf);
    printOp("inf - inf", inf, inf, inf - inf);
    printOp("-inf - (-inf)", -inf, -inf, (-inf) - (-inf));

    std.debug.print("\n--- NaN Propagation ---\n", .{});
    printOp("nan / nan", nan, nan, nan / nan);
    printOp("nan * 1", nan, one, nan * one);
    printOp("nan + 0", nan, zero, nan + zero);
    printOp("nan * 0", nan, zero, nan * zero);
    printOp("nan / 0", nan, zero, nan / zero);
    printOp1("sqrt(nan)", nan, @sqrt(nan));

    std.debug.print("\n--- Magnitude-like computation ---\n", .{});
    // Simulating v3one normalization for {inf, 0, 0}
    const v1: f32 = inf;
    const v2: f32 = 0.0;
    const v3: f32 = 0.0;
    const mag_sq = v1 * v1 + v2 * v2 + v3 * v3;
    const mag = @sqrt(mag_sq);
    const result = v1 / mag;
    std.debug.print("v3one({{inf, 0, 0}})\n", .{});
    std.debug.print("  mag_sq = {d} * {d} + {d} * {d} + {d} * {d} = {}\n", .{ v1, v1, v2, v2, v3, v3, mag_sq });
    std.debug.print("  mag = sqrt({}) = {}\n", .{ mag_sq, mag });
    std.debug.print("  result = {} / {} = {}\n", .{ v1, mag, result });
    printBits(result);

    std.debug.print("\n", .{});
}

fn printOp(op_name: []const u8, a: f32, b: f32, result: f32) void {
    std.debug.print("{s}\n", .{op_name});
    std.debug.print("  a = {}\n", .{a});
    std.debug.print("  b = {}\n", .{b});
    std.debug.print("  result = {}\n", .{result});
    printBits(result);
    std.debug.print("\n", .{});
}

fn printOp1(op_name: []const u8, a: f32, result: f32) void {
    std.debug.print("{s}\n", .{op_name});
    std.debug.print("  a = {}\n", .{a});
    std.debug.print("  result = {}\n", .{result});
    printBits(result);
    std.debug.print("\n", .{});
}

fn printBits(f: f32) void {
    const bits: u32 = @bitCast(f);
    const sign_bit = (bits >> 31) & 1;
    const exponent = (bits >> 23) & 0xFF;
    const mantissa = bits & 0x7FFFFF;

    std.debug.print("  bits: {b:0>32} (0x{x:0>8})\n", .{ bits, bits });
    std.debug.print("  sign={} exp={b:0>8} mantissa={b:0>23}\n", .{ sign_bit, exponent, mantissa });
}
