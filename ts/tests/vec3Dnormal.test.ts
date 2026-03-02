// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vec3Dnormal function using Bun's built-in test runner
 * Tests cross product calculation to find normal vector (perpendicular to both input vectors)
 * Result vector direction follows right-hand rule: CCW rotation from vec3Da to vec3Db
 */

describe("vec3Dnormal", () => {
  describe("Standard orthogonal basis vectors", () => {
    test("should return [0,0,1] for cross product of [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(1);
    });

    test("should return [0,0,-1] for cross product of [0,1,0] and [1,0,0]", () => {
      const vecA = [0, 1, 0];
      const vecB = [1, 0, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(-1);
    });

    test("should return [0,1,0] for cross product of [0,0,1] and [1,0,0]", () => {
      const vecA = [0, 0, 1];
      const vecB = [1, 0, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(1);
      expect(result[2]).toBeCloseTo(0);
    });

    test("should return [1,0,0] for cross product of [0,1,0] and [0,0,1]", () => {
      const vecA = [0, 1, 0];
      const vecB = [0, 0, 1];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
    });
  });

  describe("Arbitrary vector cross products", () => {
    test("should calculate normal for [1,2,3] and [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Cross product: (2*6 - 3*5, -(1*6 - 3*4), 1*5 - 2*4) = (-3, 6, -3)
      // Normalized result
      expect(result.length).toBe(3);
      expect(result[0]).toBeDefined();
      expect(result[1]).toBeDefined();
      expect(result[2]).toBeDefined();
    });

    test("should calculate normal for [2,3,4] and [5,6,7]", () => {
      const vecA = [2, 3, 4];
      const vecB = [5, 6, 7];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Cross product: (3*7 - 4*6, -(2*7 - 4*5), 2*6 - 3*5) = (-3, 6, -3)
      expect(result.length).toBe(3);
      expect(result[0]).toBeDefined();
      expect(result[1]).toBeDefined();
      expect(result[2]).toBeDefined();
    });

    test("should calculate normal for [1,0,0] and [0,2,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 2, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Cross product: (0*0 - 0*2, -(1*0 - 0*0), 1*2 - 0*0) = (0, 0, 2)
      expect(result.length).toBe(3);
      expect(result[2]).toBeGreaterThan(0);
    });

    test("should calculate normal for [3,4,0] and [0,0,5]", () => {
      const vecA = [3, 4, 0];
      const vecB = [0, 0, 5];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Cross product: (4*5 - 0*0, -(3*5 - 0*0), 3*0 - 4*0) = (20, -15, 0)
      expect(result.length).toBe(3);
    });
  });

  describe("Perpendicularity verification", () => {
    test("result should be perpendicular to both input vectors [1,2,3] and [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      
      // Dot product with vecA should be ~0
      const dotA = result[0] * vecA[0] + result[1] * vecA[1] + result[2] * vecA[2];
      expect(dotA).toBeCloseTo(0, 5);
      
      // Dot product with vecB should be ~0
      const dotB = result[0] * vecB[0] + result[1] * vecB[1] + result[2] * vecB[2];
      expect(dotB).toBeCloseTo(0, 5);
    });

    test("result should be perpendicular to both [2,0,0] and [0,3,0]", () => {
      const vecA = [2, 0, 0];
      const vecB = [0, 3, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      
      const dotA = result[0] * vecA[0] + result[1] * vecA[1] + result[2] * vecA[2];
      expect(dotA).toBeCloseTo(0, 5);
      
      const dotB = result[0] * vecB[0] + result[1] * vecB[1] + result[2] * vecB[2];
      expect(dotB).toBeCloseTo(0, 5);
    });
  });

  describe("Parallel and collinear vectors", () => {
    test("should return empty array for parallel vectors [1,2,3] and [2,4,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4, 6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Parallel vectors have zero cross product, normalized to [0,0,0]
      expect(result.length).toBe(3);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should handle same vector [1,1,1] and [1,1,1]", () => {
      const vecA = [1, 1, 1];
      const vecB = [1, 1, 1];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Same vector cross product is zero
      expect(result.length).toBe(3);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });

    test("should handle opposite vectors [1,2,3] and [-1,-2,-3]", () => {
      const vecA = [1, 2, 3];
      const vecB = [-1, -2, -3];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Opposite vectors are parallel, cross product is zero
      expect(result.length).toBe(3);
      expect(result[0]).toBeCloseTo(0, 5);
      expect(result[1]).toBeCloseTo(0, 5);
      expect(result[2]).toBeCloseTo(0, 5);
    });
  });

  describe("Right-hand rule verification (CCW from A to B)", () => {
    test("rotating from [1,0,0] to [0,1,0] should give positive Z direction", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Result should point in positive Z direction
      expect(result[2]).toBeGreaterThan(0);
    });

    test("rotating from [0,1,0] to [1,0,0] should give negative Z direction", () => {
      const vecA = [0, 1, 0];
      const vecB = [1, 0, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      // Result should point in negative Z direction
      expect(result[2]).toBeLessThan(0);
    });

    test("reversing input order should negate result direction", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result1 = gemm.vec3Dnormal(vecA, vecB);
      const result2 = gemm.vec3Dnormal(vecB, vecA);
      
      // Results should be opposite
      expect(result1[0]).toBeCloseTo(-result2[0], 5);
      expect(result1[1]).toBeCloseTo(-result2[1], 5);
      expect(result1[2]).toBeCloseTo(-result2[2], 5);
    });
  });

  describe("Decimal and negative vectors", () => {
    test("should calculate normal for decimal vectors [1.5, 2.5, 3.5] and [0.5, 1.5, 2.5]", () => {
      const vecA = [1.5, 2.5, 3.5];
      const vecB = [0.5, 1.5, 2.5];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
      expect(result[0]).toBeDefined();
      expect(result[1]).toBeDefined();
      expect(result[2]).toBeDefined();
    });

    test("should calculate normal for negative vectors [-1,-2,-3] and [4,5,6]", () => {
      const vecA = [-1, -2, -3];
      const vecB = [4, 5, 6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
    });

    test("should calculate normal for mixed sign vectors [1,-2,3] and [-4,5,-6]", () => {
      const vecA = [1, -2, 3];
      const vecB = [-4, 5, -6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
    });
  });

  describe("Dimension validation", () => {
    test("should return empty array for 2D vectors [1,2] and [3,4]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(0);
    });

    test("should return empty array for 4D vectors [1,2,3,4] and [5,6,7,8]", () => {
      const vecA = [1, 2, 3, 4];
      const vecB = [5, 6, 7, 8];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(0);
    });

    test("should return empty array when first vector is 2D [1,2] and second is 3D [3,4,5]", () => {
      const vecA = [1, 2];
      const vecB = [3, 4, 5];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(0);
    });

    test("should return empty array when first vector is 3D [1,2,3] and second is 2D [4,5]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(0);
    });

    test("should return empty array when first vector is 3D and second is 4D", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6, 7];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(0);
    });
  });

  describe("Normalized result", () => {
    test("result should be normalized (magnitude close to 1) for [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      
      const magnitude = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(magnitude).toBeCloseTo(1, 5);
    });

    test("result should be normalized for [3,4,0] and [0,0,5]", () => {
      const vecA = [3, 4, 0];
      const vecB = [0, 0, 5];
      const result = gemm.vec3Dnormal(vecA, vecB);
      
      const magnitude = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(magnitude).toBeCloseTo(1, 5);
    });

    test("result should be normalized for [1,2,3] and [4,5,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [4, 5, 6];
      const result = gemm.vec3Dnormal(vecA, vecB);
      
      const magnitude = Math.sqrt(result[0] ** 2 + result[1] ** 2 + result[2] ** 2);
      expect(magnitude).toBeCloseTo(1, 5);
    });
  });

  describe("Zero vectors", () => {
    test("should return empty array or zero vector for zero vector [0,0,0] and [1,2,3]", () => {
      const vecA = [0, 0, 0];
      const vecB = [1, 2, 3];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
    });

    test("should return empty array or zero vector for [1,2,3] and zero vector [0,0,0]", () => {
      const vecA = [1, 2, 3];
      const vecB = [0, 0, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
    });

    test("should handle both vectors as zero [0,0,0] and [0,0,0]", () => {
      const vecA = [0, 0, 0];
      const vecB = [0, 0, 0];
      const result = gemm.vec3Dnormal(vecA, vecB);
      expect(result.length).toBe(3);
    });
  });

});
