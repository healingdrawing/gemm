// zig/build.zig
const std = @import("std");
// artefact at the moment. wip "./test.sh" used for dev test/compare vs ts
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // === Concat step ===
    const concat_step = b.addSystemCommand(&[_][]const u8{"./test.sh"});
    //concat_step.cwd = b.build_root.handle; // .path; // Fixed for 0.16

    // Optional clean flag: zig build -Dclean
    const clean = b.option(bool, "clean", "Clean cache before build") orelse false;
    if (clean) {
        const clean_step = b.addSystemCommand(&[_][]const u8{ "rm", "-rf", ".zig-cache", "zig-cache", "zig-out" });
        //clean_step.cwd = b.build_root.path;
        concat_step.step.dependOn(&clean_step.step);
    }

    // === Main library ===
    const lib_mod = b.createModule(.{
        .root_source_file = b.path("gemm.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "gemm",
        .linkage = .static,
        .root_module = lib_mod,
    });
    lib.step.dependOn(&concat_step.step);
    b.installArtifact(lib);
}
