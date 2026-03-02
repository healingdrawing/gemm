// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDnorm function using Bun's built-in test runner
 * Tests vector length calculation (magnitude/norm) in n-dimensional space
 */

describe("vecXDnorm", () => {
  describe("Basic norm calculation", () => {
    test("should calculate norm for 2D vector [2,3]", () => {
      const vec = [2, 3];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(13)); // sqrt(4 + 9)
    });

    test("should calculate norm for 3D vector [1,2,2]", () => {
      const vec = [1, 2, 2];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(3); // sqrt(1 + 4 + 4)
    });

    test("should calculate norm for 4D vector [1,1,1,1]", () => {
      const vec = [1, 1, 1, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(2); // sqrt(1 + 1 + 1 + 1)
    });

    test("should calculate norm for 3-4-5 Pythagorean triple", () => {
      const vec = [3, 4];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(5); // sqrt(9 + 16)
    });

    test("should calculate norm for 5-12-13 Pythagorean triple", () => {
      const vec = [5, 12];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(13); // sqrt(25 + 144)
    });
  });

  describe("Zero and unit vectors", () => {
    test("should return 0 for zero vector [0,0]", () => {
      const vec = [0, 0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should return 0 for zero vector in 3D [0,0,0]", () => {
      const vec = [0, 0, 0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should return 1 for unit vector [1,0]", () => {
      const vec = [1, 0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,1]", () => {
      const vec = [0, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for unit vector [0,0,1]", () => {
      const vec = [0, 0, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(1);
    });

    test("should return 1 for normalized vector [1/sqrt(2), 1/sqrt(2)]", () => {
      const vec = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(1);
    });
  });

  describe("Negative values", () => {
    test("should handle negative coordinates [-2,-3]", () => {
      const vec = [-2, -3];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(13)); // sqrt(4 + 9)
    });

    test("should handle mixed positive and negative [-3,4]", () => {
      const vec = [-3, 4];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(5); // sqrt(9 + 16)
    });

    test("should handle all negative values [-1,-1,-1]", () => {
      const vec = [-1, -1, -1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(3)); // sqrt(1 + 1 + 1)
    });

    test("should ignore sign: norm([a,b]) = norm([-a,-b])", () => {
      const vec1 = [3, 4, 5];
      const vec2 = [-3, -4, -5];
      const result1 = gemm.vecXDnorm(vec1);
      const result2 = gemm.vecXDnorm(vec2);
      expect(result1).toBeCloseTo(result2);
    });

    test("should ignore sign with mixed values", () => {
      const vec1 = [1, -2, 3, -4];
      const vec2 = [-1, 2, -3, 4];
      const result1 = gemm.vecXDnorm(vec1);
      const result2 = gemm.vecXDnorm(vec2);
      expect(result1).toBeCloseTo(result2);
    });
  });

  describe("Single dimension vectors", () => {
    test("should calculate norm for 1D vector [5]", () => {
      const vec = [5];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(5);
    });

    test("should calculate norm for 1D vector [-7]", () => {
      const vec = [-7];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(7); // absolute value
    });

    test("should return 0 for 1D zero vector [0]", () => {
      const vec = [0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should calculate norm for 1D decimal [3.5]", () => {
      const vec = [3.5];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(3.5);
    });
  });

  describe("Decimal and floating-point values", () => {
    test("should handle decimal vector [1.5, 2.5]", () => {
      const vec = [1.5, 2.5];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(8.5)); // sqrt(2.25 + 6.25)
    });

    test("should handle small decimals [0.1, 0.2, 0.3]", () => {
      const vec = [0.1, 0.2, 0.3];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(0.14)); // sqrt(0.01 + 0.04 + 0.09)
    });

    test("should handle very small decimals [1e-5, 1e-5]", () => {
      const vec = [1e-5, 1e-5];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(2) * 1e-5);
    });

    test("should handle mixed integer and decimal [1, 2.5, 3]", () => {
      const vec = [1, 2.5, 3];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(16.25)); // sqrt(1 + 6.25 + 9)
    });
  });

  describe("Large numbers", () => {
    test("should handle large vector [1000, 2000]", () => {
      const vec = [1000, 2000];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(5000000)); // sqrt(1e6 + 4e6)
    });

    test("should handle very large numbers [1e10, 1e10]", () => {
      const vec = [1e10, 1e10];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(2) * 1e10);
    });

    test("should handle scientific notation [1e6, 2e6]", () => {
      const vec = [1e6, 2e6];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(5e12)); // sqrt(1e12 + 4e12)
    });
  });

  describe("High-dimensional spaces", () => {
    test("should calculate norm in 5D space [1,1,1,1,1]", () => {
      const vec = [1, 1, 1, 1, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(5));
    });

    test("should calculate norm in 10D space with all ones", () => {
      const vec = Array(10).fill(1);
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(10));
    });

    test("should calculate norm in 100D space with all ones", () => {
      const vec = Array(100).fill(1);
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(100)); // = 10
    });

    test("should calculate norm in 50D space with varied values", () => {
      const vec = Array(50).fill(0).map((_, i) => i + 1);
      const expectedSum = (50 * 51 * 101) / 6; // sum of squares 1 to 50
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(expectedSum));
    });

    test("should handle high-dimensional space [1,2,3,...,20]", () => {
      const vec = Array(20).fill(0).map((_, i) => i + 1);
      const expectedSum = (20 * 21 * 41) / 6; // sum of squares 1 to 20
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(expectedSum));
    });
  });

  describe("Empty and edge case vectors", () => {
    test("should return 0 for empty vector []", () => {
      const vec: Array<number> = [];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should handle vector with single zero [0]", () => {
      const vec = [0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should handle vector with multiple zeros [0,0,0,0]", () => {
      const vec = [0, 0, 0, 0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(0);
    });

    test("should handle vector with one non-zero [0,0,5,0,0]", () => {
      const vec = [0, 0, 5, 0, 0];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(5);
    });
  });

  describe("Special numeric values", () => {
    test("should handle Infinity in vector", () => {
      const vec = [Infinity, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(Infinity);
    });

    test("should handle negative Infinity in vector", () => {
      const vec = [-Infinity, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(Infinity);
    });

    test("should handle NaN in vector", () => {
      const vec = [NaN, 1, 2];
      const result = gemm.vecXDnorm(vec);
      expect(Number.isNaN(result)).toBe(true);
    });

    test("should handle Infinity with other values", () => {
      const vec = [1, 2, Infinity];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(Infinity);
    });

    test("should handle multiple Infinity values", () => {
      const vec = [Infinity, Infinity];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(Infinity);
    });
  });

  describe("Numerical precision and stability", () => {
    test("should maintain precision with [0.1, 0.2, 0.3]", () => {
      const vec = [0.1, 0.2, 0.3];
      const result = gemm.vecXDnorm(vec);
      const expected = Math.sqrt(0.01 + 0.04 + 0.09);
      expect(result).toBeCloseTo(expected, 10);
    });

    test("should handle accumulated floating-point errors", () => {
      const vec = [0.1 + 0.2, 0.3];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(0.3 * 0.3 + 0.3 * 0.3), 5);
    });

    test("should be numerically stable for very small values", () => {
      const vec = [1e-100, 1e-100];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(2) * 1e-100);
    });

    test("should be numerically stable for mixed magnitude values", () => {
      const vec = [1e-10, 1e10];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(1e10, 5); // dominated by larger value
    });
  });

  describe("Mathematical properties", () => {
    test("should satisfy homogeneity: norm(k*v) = |k| * norm(v)", () => {
      const vec = [3, 4];
      const scalar = 5;
      const scaledVec = vec.map(v => v * scalar);
      const norm1 = gemm.vecXDnorm(vec);
      const norm2 = gemm.vecXDnorm(scaledVec);
      expect(norm2).toBeCloseTo(Math.abs(scalar) * norm1);
    });

    test("should satisfy homogeneity with negative scalar", () => {
      const vec = [1, 2, 2];
      const scalar = -3;
      const scaledVec = vec.map(v => v * scalar);
      const norm1 = gemm.vecXDnorm(vec);
      const norm2 = gemm.vecXDnorm(scaledVec);
      expect(norm2).toBeCloseTo(Math.abs(scalar) * norm1);
    });

    test("should satisfy non-negativity: norm(v) >= 0", () => {
      const vectors = [
        [1, 2, 3],
        [-5, -10],
        [0, 0, 0],
        [1e-10, 1e-10]
      ];
      vectors.forEach(vec => {
        const result = gemm.vecXDnorm(vec);
        expect(result).toBeGreaterThanOrEqual(0);
      });
    });

    test("should satisfy zero property: norm(v) = 0 iff v = 0", () => {
      const zeroVec = [0, 0, 0];
      expect(gemm.vecXDnorm(zeroVec)).toBe(0);

      const nonZeroVec = [0, 0, 1e-100];
      expect(gemm.vecXDnorm(nonZeroVec)).toBeGreaterThan(0);
    });

    test("should satisfy norm invariance under sign change", () => {
      const vec = [2, 3, 4];
      const negVec = vec.map(v => -v);
      const norm1 = gemm.vecXDnorm(vec);
      const norm2 = gemm.vecXDnorm(negVec);
      expect(norm1).toBeCloseTo(norm2);
    });
  });

  describe("Return value characteristics", () => {
    test("should return a number", () => {
      const vec = [1, 2, 3];
      const result = gemm.vecXDnorm(vec);
      expect(typeof result).toBe("number");
    });

    test("should return a non-negative number", () => {
      const vectors = [
        [1, 2],
        [-3, -4],
        [0, 0],
        [5, 12]
      ];
      vectors.forEach(vec => {
        const result = gemm.vecXDnorm(vec);
        expect(result).toBeGreaterThanOrEqual(0);
      });
    });

    test("should not modify input vector", () => {
      const vec = [1, 2, 3];
      const vecCopy = [...vec];
      gemm.vecXDnorm(vec);
      expect(vec).toEqual(vecCopy);
    });

    test("should return consistent results on repeated calls", () => {
      const vec = [3, 4];
      const result1 = gemm.vecXDnorm(vec);
      const result2 = gemm.vecXDnorm(vec);
      const result3 = gemm.vecXDnorm(vec);
      expect(result1).toBe(result2);
      expect(result2).toBe(result3);
    });
  });

  describe("Common geometric cases", () => {
    test("should calculate magnitude of 3-4-5 triangle", () => {
      const vec = [3, 4];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(5);
    });

    test("should calculate magnitude of 5-12-13 triangle", () => {
      const vec = [5, 12];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(13);
    });

    test("should calculate magnitude of 8-15-17 triangle", () => {
      const vec = [8, 15];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(17);
    });

    test("should calculate magnitude of diagonal in unit cube", () => {
      const vec = [1, 1, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(3));
    });

    test("should calculate magnitude of diagonal in unit hypercube (4D)", () => {
      const vec = [1, 1, 1, 1];
      const result = gemm.vecXDnorm(vec);
      expect(result).toBe(2);
    });
  });

  describe("Comparison with Math.hypot behavior", () => {
    test("should match Math.hypot for 2D vectors", () => {
      const vec = [3, 4];
      const result = gemm.vecXDnorm(vec);
      const expected = Math.hypot(3, 4);
      expect(result).toBeCloseTo(expected);
    });

    test("should match Math.hypot for 3D vectors", () => {
      const vec = [1, 2, 2];
      const result = gemm.vecXDnorm(vec);
      const expected = Math.hypot(1, 2, 2);
      expect(result).toBeCloseTo(expected);
    });

    test("should match manual calculation for [2, 3]", () => {
      const vec = [2, 3];
      const result = gemm.vecXDnorm(vec);
      const expected = Math.sqrt(2 * 2 + 3 * 3);
      expect(result).toBeCloseTo(expected);
    });
  });

  describe("Performance characteristics", () => {
    test("should handle vector with 1000 elements", () => {
      const vec = Array(1000).fill(1);
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(1000));
    });

    test("should handle vector with 10000 elements efficiently", () => {
      const vec = Array(10000).fill(0.1);
      const result = gemm.vecXDnorm(vec);
      expect(result).toBeCloseTo(Math.sqrt(10000 * 0.01)); // sqrt(100)
    });
  });
});
