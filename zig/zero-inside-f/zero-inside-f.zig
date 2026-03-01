// zero-inside-f.zig
/// Return true if incoming Float array has at least one zero element
/// Arguments:
///     a - incoming array
pub fn zero_inside_F(a: []f32) bool {
    const Vec = blk: {
        // Use 16 if available, otherwise 8, otherwise 4
        if (@sizeOf(@Vector(16, f32)) == 64) {
            break :blk @Vector(16, f32);
        } else if (@sizeOf(@Vector(8, f32)) == 32) {
            break :blk @Vector(8, f32);
        } else {
            break :blk @Vector(4, f32);
        }
    };

    const vector_size = @typeInfo(Vec).vector.len;
    const simd_len = a.len / vector_size;

    // SIMD: process elements at a time
    var i: usize = 0;
    while (i < simd_len) : (i += 1) {
        const vec: Vec = a[i * vector_size ..][0..vector_size].*;
        const cmp = vec == @as(Vec, @splat(@as(f32, 0)));
        if (@reduce(.Or, cmp)) {
            return true;
        }
    }

    // Scalar: handle remaining elements
    var j = simd_len * vector_size;
    while (j < a.len) : (j += 1) {
        if (a[j] == 0) {
            return true;
        }
    }

    return false;
}
