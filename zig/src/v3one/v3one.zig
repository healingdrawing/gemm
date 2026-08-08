// src/v3one/v3one.zig
const math = @import("std").math;

// bench section, changed on the fly. Context: (fastest) and/or (the less noise)
pub inline fn v3one_machine_1(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag = @sqrt(@mulAdd(f32, x, x, @mulAdd(f32, y, y, @mulAdd(f32, z, z, 0))));

    if (mag > 0) {
        const gam = 1 / mag;
        return v3 * @as(@Vector(3, f32), .{ gam, gam, gam });
    }
    return v3;
}

pub inline fn v3one_machine_2(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const xx = @mulAdd(f32, x, x, 0);
    const yy = @mulAdd(f32, y, y, 0);
    const zz = @mulAdd(f32, z, z, 0);

    const mag = @sqrt(xx + yy + zz);
    var v3c = v3;
    if (mag > 0) {
        const gam = 1 / mag;
        v3c[0] = @mulAdd(f32, x, gam, 0);
        v3c[1] = @mulAdd(f32, y, gam, 0);
        v3c[2] = @mulAdd(f32, z, gam, 0);
    }
    return v3c;
}

pub inline fn v3one_machine_3(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag = @sqrt(@mulAdd(f32, x, x, @mulAdd(f32, y, y, @mulAdd(f32, z, z, 0))));

    const gam = 1 / mag;

    if (mag > 0) {
        return v3 * @as(@Vector(3, f32), .{ gam, gam, gam });
    }
    return v3;
}

pub inline fn v3one_machine_4(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag = @sqrt(@mulAdd(f32, x, x, @mulAdd(f32, y, y, @mulAdd(f32, z, z, 0))));

    var v3c = v3;

    if (mag > 0) {
        const gam = 1 / mag;
        v3c[0] = @mulAdd(f32, x, gam, 0);
        v3c[1] = @mulAdd(f32, y, gam, 0);
        v3c[2] = @mulAdd(f32, z, gam, 0);
    }
    return v3c;
}

pub inline fn v3one_machine_5(v3: @Vector(3, f32)) @Vector(3, f32) {
    const xx = @mulAdd(f32, v3[0], v3[0], 0);
    const yy = @mulAdd(f32, v3[1], v3[1], 0);
    const zz = @mulAdd(f32, v3[2], v3[2], 0);

    const mag = @sqrt(xx + yy + zz);

    if (mag > 0) {
        const gam = 1 / mag;
        return v3 * @as(@Vector(3, f32), .{ gam, gam, gam });
    }
    return v3;
}

pub inline fn v3one_machine_6(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag = @sqrt(@mulAdd(f32, x, x, 0) + @mulAdd(f32, y, y, 0) + @mulAdd(f32, z, z, 0));

    var v3c = v3;

    if (mag > 0) {
        const gam = 1 / mag;
        v3c[0] = @mulAdd(f32, x, gam, 0);
        v3c[1] = @mulAdd(f32, y, gam, 0);
        v3c[2] = @mulAdd(f32, z, gam, 0);
    }
    return v3c;
}

pub inline fn v3one_machine_7(v3: @Vector(3, f32)) @Vector(3, f32) {
    const vv = v3 * v3;
    const mag = @sqrt(vv[0] + vv[1] + vv[2]);

    if (mag > 0) {
        const gam = 1 / mag;
        const v: @Vector(3, f32) = .{ gam, gam, gam };
        return v3 * v;
    }
    return v3;
}

pub inline fn v3one_machine_8(v3: *@Vector(3, f32)) void {
    const gam = 1 / @sqrt(@mulAdd(f32, v3[0], v3[0], @mulAdd(f32, v3[1], v3[1], @mulAdd(f32, v3[2], v3[2], 0))));

    if (gam > 0) {
        v3[0] *= gam;
        v3[1] *= gam;
        v3[2] *= gam;
    }
}

pub inline fn v3one_std_1(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const gam = 1 / @sqrt(x * x + y * y + z * z);

    if (gam > 0) return .{ x * gam, y * gam, z * gam };

    return v3;
}

pub inline fn v3one_std_2(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const gam = 1 / math.sqrt(x * x + y * y + z * z);

    if (gam > 0) return .{ x * gam, y * gam, z * gam };

    return v3;
}

pub inline fn v3one_std_3(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag_squared = x * x + y * y + z * z;
    const mag = @sqrt(mag_squared);

    if (mag > 0) {
        return .{ x / mag, y / mag, z / mag };
    }
    return v3;
}

pub inline fn v3one_std_4(v3: *@Vector(3, f32)) void {
    const gam = 1 / @sqrt(v3[0] * v3[0] + v3[1] * v3[1] + v3[2] * v3[2]);

    if (gam > 0) {
        v3[0] *= gam;
        v3[1] *= gam;
        v3[2] *= gam;
    }
}

//warning it is very strange bench stable demonstrated on dev machine that std.math.sqrt tiny bit faster than @sqrt. but in zig source the std.math.sqrt call @sqrt from switch case... and description says @sqrt uses machine bla bla , and suitable for float/float vectors. it is ... weird. Finally v3one uses @sqrt, against bench. facepalm

// Everything below concat marker line will be copied into gemm.zig
//-concat marker

/// Normalize a 3D vector to unit length if magnitude > 0.
/// Otherwise, return unchanged vector.
pub inline fn v3one(v3: @Vector(3, f32)) @Vector(3, f32) {
    const x = v3[0];
    const y = v3[1];
    const z = v3[2];

    const mag2 = x * x + y * y + z * z;

    if (mag2 > 0.0) {
        const mag = @sqrt(mag2);
        const inv = 1.0 / mag;
        return .{ x * inv, y * inv, z * inv };
    }

    return v3;
}
