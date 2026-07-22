const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the implementation module
    const impl_mod = b.createModule(.{
        .root_source_file = b.path("v3v3scalar.zig"),
    });

    // Create the executable
    const exe = b.addExecutable(.{
        .name = "cli_v3v3scalar",
        .root_module = b.createModule(.{
            .root_source_file = b.path("cli_v3v3scalar.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Add import
    exe.root_module.addImport("v3v3scalar", impl_mod);

    b.installArtifact(exe);

    // Optional run step
    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run this CLI tool");
    run_step.dependOn(&run_cmd.step);
}
