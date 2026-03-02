// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for vecXDangle function using Bun's built-in test runner
 * Tests angle calculation between two vectors in n-dimensional space
 * Returns angle in degrees by default, or radians if rad parameter is true
 */

describe("vecXDangle", () => {
  describe("Basic angle calculation in degrees", () => {
    test("should calculate 90 degrees between perpendicular vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(90);
    });

    test("should calculate 0 degrees between parallel vectors [1,0] and [2,0]", () => {
      const vecA = [1, 0];
      const vecB = [2, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should calculate 180 degrees between opposite vectors [1,0] and [-1,0]", () => {
      const vecA = [1, 0];
      const vecB = [-1, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(180);
    });

    test("should calculate 60 degrees between vectors [1,0] and [1,Math.sqrt(3)]", () => {
      const vecA = [1, 0];
      const vecB = [1, Math.sqrt(3)];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(60);
    });

    test("should calculate 45 degrees between vectors [1,0] and [1,1]", () => {
      const vecA = [1, 0];
      const vecB = [1, 1];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(45);
    });
  });

  describe("Angle calculation in 3D space", () => {
    test("should calculate 90 degrees between perpendicular 3D vectors [1,0,0] and [0,1,0]", () => {
      const vecA = [1, 0, 0];
      const vecB = [0, 1, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(90);
    });

    test("should calculate 0 degrees between parallel 3D vectors [1,2,3] and [2,4,6]", () => {
      const vecA = [1, 2, 3];
      const vecB = [2, 4, 6];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should calculate correct angle between [1,1,0] and [0,0,1]", () => {
      const vecA = [1, 1, 0];
      const vecB = [0, 0, 1];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(90);
    });
  });

  describe("Angle calculation in radians", () => {
    test("should calculate π/2 radians between perpendicular vectors [1,0] and [0,1]", () => {
      const vecA = [1, 0];
      const vecB = [0, 1];
      const result = gemm.vecXDangle(vecA, vecB, true);
      expect(result).toBeCloseTo(Math.PI / 2);
    });

    test("should calculate 0 radians between parallel vectors [1,0] and [2,0]", () => {
      const vecA = [1, 0];
      const vecB = [2, 0];
      const result = gemm.vecXDangle(vecA, vecB, true);
      expect(result).toBeCloseTo(0);
    });

    test("should calculate π radians between opposite vectors [1,0] and [-1,0]", () => {
      const vecA = [1, 0];
      const vecB = [-1, 0];
      const result = gemm.vecXDangle(vecA, vecB, true);
      expect(result).toBeCloseTo(Math.PI);
    });

    test("should calculate π/3 radians between vectors [1,0] and [1,Math.sqrt(3)]", () => {
      const vecA = [1, 0];
      const vecB = [1, Math.sqrt(3)];
      const result = gemm.vecXDangle(vecA, vecB, true);
      expect(result).toBeCloseTo(Math.PI / 3);
    });

    test("should calculate π/4 radians between vectors [1,0] and [1,1]", () => {
      const vecA = [1, 0];
      const vecB = [1, 1];
      const result = gemm.vecXDangle(vecA, vecB, true);
      expect(result).toBeCloseTo(Math.PI / 4);
    });
  });

  describe("Edge cases with zero vectors", () => {
    test("should return 0 when first vector is zero [0,0] and [1,0]", () => {
      const vecA = [0, 0];
      const vecB = [1, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when second vector is zero [1,0] and [0,0]", () => {
      const vecA = [1, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when both vectors are zero [0,0] and [0,0]", () => {
      const vecA = [0, 0];
      const vecB = [0, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBe(0);
    });

    test("should return 0 when first 3D vector is zero [0,0,0] and [1,2,3]", () => {
      const vecA = [0, 0, 0];
      const vecB = [1, 2, 3];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBe(0);
    });
  });

  describe("Normalized and scaled vectors", () => {
    test("should calculate same angle for scaled vectors [1,0] and [2,0]", () => {
      const vecA = [1, 0];
      const vecB = [2, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });

    test("should calculate same angle for scaled perpendicular vectors [2,0] and [0,3]", () => {
      const vecA = [2, 0];
      const vecB = [0, 3];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(90);
    });

    test("should calculate same angle for normalized vectors [1/Math.sqrt(2), 1/Math.sqrt(2)] and [1,0]", () => {
      const vecA = [1 / Math.sqrt(2), 1 / Math.sqrt(2)];
      const vecB = [1, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(45);
    });
  });

  describe("Higher dimensional vectors", () => {
    test("should calculate angle between 4D vectors [1,0,0,0] and [0,1,0,0]", () => {
      const vecA = [1, 0, 0, 0];
      const vecB = [0, 1, 0, 0];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(90);
    });

    test("should calculate angle between 5D parallel vectors [1,1,1,1,1] and [2,2,2,2,2]", () => {
      const vecA = [1, 1, 1, 1, 1];
      const vecB = [2, 2, 2, 2, 2];
      const result = gemm.vecXDangle(vecA, vecB);
      expect(result).toBeCloseTo(0);
    });
  });

});
