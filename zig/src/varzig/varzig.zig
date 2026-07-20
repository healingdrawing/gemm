//-concat marker
pub fn varzig() void {
    //todo it should fail some way when lib tested since const used, keep it for now
    const v3: [3]u8 = .{ 1, 3, 4 };
    callme(v3);
    return v3;
}

pub fn callme(v3: [3]u8) void {
    v3[0] = 2;
}
