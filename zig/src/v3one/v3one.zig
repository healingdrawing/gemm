// src/v3one/v3one.zig
const std = @import("std");

// bench section, changed on the fly. Context: (fastest) and/or (the less noise)
pub inline fn v3one_filtered_division_solid_mag(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag = std.math.sqrt(x * x + y * y + z * z);

    if (mag > 0) {
        return .{ x / mag, y / mag, z / mag };
    }
    return v3;
}

pub inline fn v3one_always_division_solid_mag(v3: @Vector(3, f32)) @Vector(3, f32) {
    var x = v3[0];
    var y = v3[1];
    var z = v3[2];

    const mag = std.math.sqrt(x * x + y * y + z * z);

    x /= mag;
    y /= mag;
    z /= mag;

    if (mag > 0) {
        return .{ x, y, z };
    }
    return v3;
}

pub inline fn v3one_filtered_division_sequent_mag(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag_squared = x * x + y * y + z * z;
    const mag = std.math.sqrt(mag_squared);

    if (mag > 0) {
        return .{ x / mag, y / mag, z / mag };
    }
    return v3;
}

pub inline fn v3one_always_division_sequent_mag(v3: @Vector(3, f32)) @Vector(3, f32) {
    var x = v3[0];
    var y = v3[1];
    var z = v3[2];

    const mag_squared = x * x + y * y + z * z;
    const mag = std.math.sqrt(mag_squared);

    x /= mag;
    y /= mag;
    z /= mag;

    if (mag > 0) {
        return .{ x, y, z };
    }
    return v3;
}

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Normalize a 3D vector to unit length if magnitude > 0.
/// Otherwise, return unchanged vector.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    var x = v3[0];
    var y = v3[1];
    var z = v3[2];

    const mag = std.math.sqrt(x * x + y * y + z * z);

    x /= mag;
    y /= mag;
    z /= mag;

    if (mag > 0) {
        return .{ x, y, z };
    }
    return v3;
}
