// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDone function using Bun's built-in test runner
 * Tests vector normalization to unit length (magnitude = 1)
 */

describe("vecXDone", () => {
  describe("Basic normalization", () => {
    test("should normalize 2D vector [3,4] to unit length", () => {
      const vec = [3, 4];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(0.6); // 3/5
      expect(result[1]).toBeCloseTo(0.8); // 4/5
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize 3D vector [1,2,2] to unit length", () => {
      const vec = [1, 2, 2];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(1/3); // 1/3
      expect(result[1]).toBeCloseTo(2/3); // 2/3
      expect(result[2]).toBeCloseTo(2/3); // 2/3
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize 4D vector [1,1,1,1] to unit length", () => {
      const vec = [1, 1, 1, 1];
      const result = gemm.vecXDone(vec);
      const expected = 1 / 2; // 1/sqrt(4)
      expect(result[0]).toBeCloseTo(expected);
      expect(result[1]).toBeCloseTo(expected);
      expect(result[2]).toBeCloseTo(expected);
      expect(result[3]).toBeCloseTo(expected);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize 5-12-13 Pythagorean triple [5,12]", () => {
      const vec = [5, 12];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(5/13);
      expect(result[1]).toBeCloseTo(12/13);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });
  });

  describe("Already normalized vectors", () => {
    test("should return unit vector [1,0] unchanged", () => {
      const vec = [1, 0];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(0);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should return unit vector [0,1] unchanged", () => {
      const vec = [0, 1];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(1);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should return normalized vector [1/sqrt(2), 1/sqrt(2)] unchanged", () => {
      const vec = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(1 / Math.sqrt(2));
      expect(result[1]).toBeCloseTo(1 / Math.sqrt(2));
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });
  });

  describe("Zero vector", () => {
    test("should return zero vector [0,0] unchanged", () => {
      const vec = [0, 0];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBe(0);
      expect(result[1]).toBe(0);
    });

    test("should return zero vector [0,0,0] unchanged", () => {
      const vec = [0, 0, 0];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBe(0);
      expect(result[1]).toBe(0);
      expect(result[2]).toBe(0);
    });
  });

  describe("Negative and decimal vectors", () => {
    test("should normalize vector with negative values [-3,-4]", () => {
      const vec = [-3, -4];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(-0.6); // -3/5
      expect(result[1]).toBeCloseTo(-0.8); // -4/5
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize vector with decimal values [1.5, 2.0]", () => {
      const vec = [1.5, 2.0];
      const result = gemm.vecXDone(vec);
      const norm = Math.sqrt(1.5 * 1.5 + 2.0 * 2.0); // 2.5
      expect(result[0]).toBeCloseTo(1.5 / norm);
      expect(result[1]).toBeCloseTo(2.0 / norm);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize mixed positive/negative vector [2, -2, 1]", () => {
      const vec = [2, -2, 1];
      const result = gemm.vecXDone(vec);
      const norm = Math.sqrt(4 + 4 + 1); // 3
      expect(result[0]).toBeCloseTo(2/3);
      expect(result[1]).toBeCloseTo(-2/3);
      expect(result[2]).toBeCloseTo(1/3);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });
  });

  describe("High-dimensional vectors", () => {
    test("should normalize 10D vector correctly", () => {
      const vec = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
      const result = gemm.vecXDone(vec);
      const norm = Math.sqrt(10);
      const expected = 1 / norm;
      for (let i = 0; i < 10; i++) {
        expect(result[i]).toBeCloseTo(expected);
      }
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize 5D vector [1,2,3,4,5]", () => {
      const vec = [1, 2, 3, 4, 5];
      const result = gemm.vecXDone(vec);
      const norm = Math.sqrt(1 + 4 + 9 + 16 + 25); // sqrt(55)
      for (let i = 0; i < 5; i++) {
        expect(result[i]).toBeCloseTo(vec[i] / norm);
      }
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });
  });

  describe("Single element vectors", () => {
    test("should normalize single positive element [5]", () => {
      const vec = [5];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(1);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });

    test("should normalize single negative element [-7]", () => {
      const vec = [-7];
      const result = gemm.vecXDone(vec);
      expect(result[0]).toBeCloseTo(-1);
      expect(gemm.vecXDnorm(result)).toBeCloseTo(1);
    });
  });

});
