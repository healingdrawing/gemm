// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for projection_dot3D_on_plane3D function using Bun's built-in test runner
 * Tests projection of a 3D point onto a 3D plane
 */

describe("projection_dot3D_on_plane3D", () => {
  describe("Basic projections on coordinate planes", () => {
    test("should project point [1, 2, 3] onto XY plane (Z=0)", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 0, 1, 0]; // normal [0,0,1], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project point [1, 2, 3] onto YZ plane (X=0)", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [1, 0, 0, 0]; // normal [1,0,0], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(3);
    });

    test("should project point [1, 2, 3] onto XZ plane (Y=0)", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 1, 0, 0]; // normal [0,1,0], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(3);
    });
  });

  describe("Projections on planes with non-zero distance", () => {
    test("should project point onto plane Z=5", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 0, 1, -5]; // normal [0,0,1], d=-5 (plane at Z=5)
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(5);
    });

    test("should project point onto plane X=3", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [1, 0, 0, -3]; // normal [1,0,0], d=-3 (plane at X=3)
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(3);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(3);
    });

    test("should project point onto plane Y=-2", () => {
      const dot3D = [5, 5, 5];
      const plane3D = [0, 1, 0, 2]; // normal [0,1,0], d=2 (plane at Y=-2)
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(5);
      expect(result[1]).toBeCloseTo(-2);
      expect(result[2]).toBeCloseTo(5);
    });
  });

  describe("Projections on tilted planes", () => {
    test("should project point onto plane with normal [1, 1, 0]", () => {
      const dot3D = [1, 1, 0];
      const plane3D = [1, 1, 0, 0]; // normal [1,1,0], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project point onto plane with normal [1, 1, 1]", () => {
      const dot3D = [3, 3, 3];
      const plane3D = [1, 1, 1, 0]; // normal [1,1,1], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project point onto tilted plane with normal [1, 1, 1] and d=-3", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 1, 1, -3]; // plane: x + y + z = 3
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(1);
      expect(result[2]).toBeCloseTo(1);
    });

    test("should project point onto plane with normal [1, 2, 2]", () => {
      const dot3D = [9, 0, 0];
      const plane3D = [1, 2, 2, 0]; // normal [1,2,2], d=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(8);
      expect(result[1]).toBeCloseTo(-2);
      expect(result[2]).toBeCloseTo(-2);
    });
  });

  describe("Point already on plane", () => {
    test("should return same point when already on plane", () => {
      const dot3D = [1, 2, 0];
      const plane3D = [0, 0, 1, 0]; // XY plane
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([1, 2, 0]);
    });

    test("should return same point on tilted plane", () => {
      const dot3D = [1, 1, 1];
      const plane3D = [1, 1, 1, -3]; // plane: x + y + z = 3
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([1, 1, 1]);
    });

    test("should return same point on plane X=5", () => {
      const dot3D = [5, 10, -3];
      const plane3D = [1, 0, 0, -5]; // plane at X=5
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([5, 10, -3]);
    });
  });

  describe("Dimension validation", () => {
    test("should return empty array when dot3D is not 3D", () => {
      const dot3D = [1, 2];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D is 4D", () => {
      const dot3D = [1, 2, 3, 4];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when plane3D is not 4D", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 0, 1];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when plane3D is 5D", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 0, 1, 0, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid plane normal", () => {
    test("should return empty array when plane normal is zero vector [0, 0, 0]", () => {
      const dot3D = [1, 2, 3];
      const plane3D = [0, 0, 0, 5];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });

    test("should return empty array when plane normal is [0, 0, 0] with d=0", () => {
      const dot3D = [5, 5, 5];
      const plane3D = [0, 0, 0, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result).toEqual([]);
    });
  });

  describe("Negative coordinates", () => {
    test("should project negative point onto XY plane", () => {
      const dot3D = [-1, -2, -3];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(-1);
      expect(result[1]).toBeCloseTo(-2);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project point onto plane with negative d value", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [0, 0, 1, 10]; // plane at Z=-10
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(-10);
    });

    test("should project negative point onto tilted plane", () => {
      const dot3D = [-3, -3, -3];
      const plane3D = [1, 1, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });

  describe("Scaled plane normals", () => {
    test("should project onto plane with scaled normal [2, 0, 0]", () => {
      const dot3D = [5, 2, 3];
      const plane3D = [2, 0, 0, 0]; // scaled normal, plane at X=0
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(3);
    });

    test("should project onto plane with scaled normal [3, 3, 3]", () => {
      const dot3D = [6, 6, 6];
      const plane3D = [3, 3, 3, 0]; // scaled normal
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project onto plane with scaled normal [0.5, 0.5, 0.5]", () => {
      const dot3D = [3, 3, 3];
      const plane3D = [0.5, 0.5, 0.5, 0]; // scaled normal
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });

  describe("Complex geometric scenarios", () => {
    test("should project origin onto plane X+Y+Z=6", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 1, 1, -6];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(2);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(2);
    });

    test("should project point far from plane", () => {
      const dot3D = [100, 0, 0];
      const plane3D = [1, 0, 0, 0]; // YZ plane
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should project point on plane with normal [1, 2, 2] and d=-9", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 2, 2, -9]; // plane: x + 2y + 2z = 9
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(2);
      expect(result[2]).toBeCloseTo(2);
    });
  });

  describe("Floating point precision", () => {
    test("should handle decimal coordinates", () => {
      const dot3D = [1.5, 2.5, 3.5];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(1.5);
      expect(result[1]).toBeCloseTo(2.5);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should handle small decimal values", () => {
      const dot3D = [0.001, 0.002, 0.003];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0.001);
      expect(result[1]).toBeCloseTo(0.002);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should handle very small normal vector components", () => {
      const dot3D = [1000, 1000, 1000];
      const plane3D = [0.001, 0.001, 0.001, 0];
      const result = gemm.projection_dot3D_on_plane3D(dot3D, plane3D);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });
});
