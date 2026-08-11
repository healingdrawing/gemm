const std = @import("std");
const dp = @import("../utils/debug.zig");

pub const MethodResult = struct {
    name: []const u8,
    total: usize,
    failed: usize,

    pub fn passed(self: MethodResult) usize {
        return self.total - self.failed;
    }
};

pub fn print_test_sum_report(results: []const MethodResult) void {
    var total_executed: usize = 0;
    var total_failed: usize = 0;

    for (results) |r| {
        total_executed += r.total;
        total_failed += r.failed;
    }
    const total_passed = total_executed - total_failed;

    const pct = struct {
        fn f(part: usize, whole: usize) usize {
            if (whole == 0) return 0;
            return (part * 100) / whole;
        }
    }.f;

    dp.rawdevlog(.{ "summary ", results.len, " methods tested" });
    dp.rawdevlog(.{ pct(total_executed, total_executed), "% tests executed: ", total_executed });
    const passed = pct(total_passed, total_executed);
    dp.rawdevlog(.{ passed, "% tests passed: ", total_passed });
    dp.rawdevlog(.{ 100 - passed, "% tests failed : ", total_failed });

    if (total_failed > 0) {
        for (results) |r| {
            if (r.failed > 0) {
                dp.rawerrlog(.{ r.failed, " tests failed by ", r.name });
            }
        }
    }
}
