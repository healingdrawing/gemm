import { test, expect, describe } from "bun:test";
import { GEMM } from "./gemm";
const gemm = new GEMM()
/**
 * Test suite for distance_dot3D_plane3D function using Bun's built-in test runner
 */

describe("distance_dot3D_plane3D", () => {
  // Helper function to compare floating point numbers
  const expectClose = (actual: number, expected: number, tolerance: number = 1e-10) => {
    expect(Math.abs(actual - expected)).toBeLessThan(tolerance);
  };

  describe("Basic distance calculations", () => {
    test("should calculate distance from point to plane with unit normal vector", () => {
      // Plane: x + y + z = 0
      // Point: (1, 1, 1)
      // Distance = 3/sqrt(3) = sqrt(3)
      const dot3D = [1, 1, 1];
      const plane3D = [1, 1, 1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });

    test("should calculate distance from point on the plane (distance = 0)", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 1, 1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 0);
    });

    test("should calculate distance with plane displacement (d != 0)", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 1, 1, -3];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });

    test("should calculate distance with negative plane displacement", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [2, 2, 2, 4];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 2 / Math.sqrt(3));
    });
  });

  describe("Coordinate plane tests", () => {
    test("should calculate distance to XY plane (z=0)", () => {
      const dot3D = [5, 3, 7];
      const plane3D = [0, 0, 1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 7);
    });

    test("should calculate distance to XZ plane (y=0)", () => {
      const dot3D = [2, -4, 6];
      const plane3D = [0, 1, 0, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 4);
    });

    test("should calculate distance to YZ plane (x=0)", () => {
      const dot3D = [3, 1, 2];
      const plane3D = [1, 0, 0, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 3);
    });
  });

  describe("Negative coordinates", () => {
    test("should handle negative point coordinates", () => {
      const dot3D = [-1, -1, -1];
      const plane3D = [1, 1, 1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });

    test("should handle negative normal vector components", () => {
      const dot3D = [1, 1, 1];
      const plane3D = [-1, -1, -1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });
  });

  describe("Zero and near-zero values", () => {
    test("should handle point at origin", () => {
      const dot3D = [0, 0, 0];
      const plane3D = [1, 1, 1, -5];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 5 / Math.sqrt(3));
    });

    test("should handle plane through origin", () => {
      const dot3D = [2, 3, 6];
      const plane3D = [2, 3, 6, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 7);
    });

    test("should return 0 for point on plane with non-unit normal", () => {
      const dot3D = [1, 1, 1];
      const plane3D = [2, 2, 2, -6];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 0);
    });
  });

  describe("Large numbers", () => {
    test("should handle large coordinate values", () => {
      const dot3D = [1000, 500, 250];
      const plane3D = [1, 0, 0, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 1000);
    });

    test("should handle large plane coefficients", () => {
      const dot3D = [1, 1, 1];
      const plane3D = [1000, 1000, 1000, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });
  });

  describe("Small numbers and decimals", () => {
    test("should handle small decimal coordinates", () => {
      const dot3D = [0.1, 0.1, 0.1];
      const plane3D = [1, 1, 1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 0.3 / Math.sqrt(3));
    });

    test("should handle small plane coefficients", () => {
      const dot3D = [1, 1, 1];
      const plane3D = [0.1, 0.1, 0.1, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, Math.sqrt(3));
    });
  });

  describe("Oblique planes", () => {
    test("should calculate distance to an oblique plane", () => {
      const dot3D = [3, 4, 100];
      const plane3D = [3, 4, 0, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 5);
    });

    test("should calculate distance with mixed normal vector", () => {
      const dot3D = [1, 2, 2];
      const plane3D = [1, 2, 2, 0];
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
      expectClose(result, 3);
    });
  });

  describe("Distance formula validation", () => {
    test("should always return non-negative distance", () => {
      const testCases = [
        { dot3D: [1, 2, 3], plane3D: [1, 0, 0, 0] },
        { dot3D: [-5, -3, -1], plane3D: [2, 2, 2, 5] },
        { dot3D: [0.5, 0.5, 0.5], plane3D: [1, 1, 1, -10] },
      ];

      testCases.forEach(({ dot3D, plane3D }) => {
        const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);
        expect(result).toBeGreaterThanOrEqual(0);
      });
    });

    test("should satisfy distance formula: |ax + by + cz + d| / sqrt(a² + b² + c²)", () => {
      const dot3D = [2, 3, 4];
      const plane3D = [1, 2, 3, 5];
      const [a, b, c, d] = plane3D;
      const [x, y, z] = dot3D;

      const expected =
        Math.abs(a * x + b * y + c * z + d) /
        Math.sqrt(a * a + b * b + c * c);
      const result = gemm.distance_dot3D_plane3D(dot3D, plane3D);

      expectClose(result, expected);
    });
  });

  describe("Symmetry tests", () => {
    test("should give same distance for opposite sides of plane", () => {
      const plane3D = [1, 0, 0, 0];
      const distance1 = gemm.distance_dot3D_plane3D([5, 0, 0], plane3D);
      const distance2 = gemm.distance_dot3D_plane3D([-5, 0, 0], plane3D);

      expectClose(distance1, distance2);
      expectClose(distance1, 5);
    });

    test("should be invariant to scaling normal vector", () => {
      const dot3D = [1, 1, 1];
      const plane3D_1 = [1, 1, 1, 0];
      const plane3D_2 = [2, 2, 2, 0];
      const plane3D_3 = [0.5, 0.5, 0.5, 0];

      const result1 = gemm.distance_dot3D_plane3D(dot3D, plane3D_1);
      const result2 = gemm.distance_dot3D_plane3D(dot3D, plane3D_2);
      const result3 = gemm.distance_dot3D_plane3D(dot3D, plane3D_3);

      expectClose(result1, result2);
      expectClose(result2, result3);
    });
  });
});
