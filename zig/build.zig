// zig/build.zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // === Concat step ===
    const concat_step = b.addSystemCommand(&[_][]const u8{"./concat.sh"});
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

    // === Tests ===
    const tests = b.addTest(.{
        .root_module = lib_mod,
    });
    tests.step.dependOn(&concat_step.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);

    // === WASM target ===
    const wasm_mod = b.createModule(.{
        .root_source_file = b.path("gemm.zig"),
        .target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding }),
        .optimize = optimize,
    });

    const wasm = b.addLibrary(.{
        .name = "gemm_wasm",
        .linkage = .static,
        .root_module = wasm_mod,
    });
    wasm.step.dependOn(&concat_step.step);
    b.installArtifact(wasm);

    // === WASM binary ===
    const wasm_bin = b.addExecutable(.{
        .name = "gemm",
        .root_module = wasm_mod,
    });
    wasm_bin.step.dependOn(&concat_step.step);
    wasm_bin.entry = .disabled;
    wasm_bin.rdynamic = true;
    b.installArtifact(wasm_bin);

    // === FFI Shared Library (for Bun FFI) ===
    const ffi_mod = b.createModule(.{
        .root_source_file = b.path("gemm.zig"),
        .target = target,
        .optimize = optimize,
    });

    const ffi = b.addLibrary(.{
        .name = "gemm",
        .linkage = .dynamic,
        .root_module = ffi_mod,
    });
    ffi.step.dependOn(&concat_step.step);
    b.installArtifact(ffi);
}
