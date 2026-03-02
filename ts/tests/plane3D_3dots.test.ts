// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for plane3D_3dots function using Bun's built-in test runner
 * Tests 3D plane equation calculation from three non-collinear points
 * The plane is determined by computing vectors from the first point to the other two,
 * then calculating the normal via cross product and normalizing it
 * Where (a, b, c) is the normal vector and d is the displacement from origin
 */

describe("plane3D_3dots", () => {
  describe("Valid plane calculations with standard points", () => {
    test("should calculate plane from three points forming XY plane", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 1, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,0,0] and [0,1,0]
      // Cross product = [0,0,1]
      // Normalized = [0,0,1]
      // d = -(0*0 + 0*0 + 1*0) = 0
      expect(result).toEqual([0, 0, 1, -0]);
    });

    test("should calculate plane from three points forming XZ plane", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 0, 1];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,0,0] and [0,0,1]
      // Cross product = [0,-1,0]
      // Normalized = [0,-1,0]
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(-1);
      expect(result[2]).toBeCloseTo(0);
      expect(result[3]).toBeCloseTo(0);
    });

    test("should calculate plane from three points forming YZ plane", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0, 1, 0];
      const dot3Db = [0, 0, 1];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [0,1,0] and [0,0,1]
      // Cross product = [1,0,0]
      // Normalized = [1,0,0]
      expect(result[0]).toBeCloseTo(1);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(0);
      expect(result[3]).toBeCloseTo(0);
    });
  });

  describe("Valid plane calculations with arbitrary points", () => {
    test("should calculate plane from three arbitrary points [1,2,3], [4,5,6], [7,8,10]", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [4, 5, 6];
      const dot3Db = [7, 8, 10];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [3,3,3] and [6,6,7]
      // Cross product = [3,-3,0]
      // Norm = sqrt(18) = 3*sqrt(2)
      // Normalized = [1/sqrt(2), -1/sqrt(2), 0]
      // d = -(1/sqrt(2)*1 + (-1/sqrt(2))*2 + 0*3) = -(-1/sqrt(2)) = 1/sqrt(2)
      const norm = Math.sqrt(2);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(-1 / norm);
      expect(result[2]).toBeCloseTo(0);
      expect(result[3]).toBeCloseTo(1 / norm);
    });

    test("should calculate plane from three points on same plane", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 2, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,0,0] and [0,2,0]
      // Cross product = [0,0,2]
      // Normalized = [0,0,1]
      expect(result).toEqual([0, 0, 1, -0]);
    });

    test("should calculate plane from three points with negative coordinates", () => {
      const dot3D = [-1, -2, -3];
      const dot3Da = [0, -2, -3];
      const dot3Db = [-1, -1, -3];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,0,0] and [0,1,0]
      // Cross product = [0,0,1]
      // Normalized = [0,0,1]
      // d = -(0*(-1) + 0*(-2) + 1*(-3)) = 3
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(1);
      expect(result[3]).toBeCloseTo(3);
    });
  });

  describe("Invalid input - wrong array lengths", () => {
    test("should return empty array when dot3D has length 2", () => {
      const dot3D = [1, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 1, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D has length 4", () => {
      const dot3D = [1, 0, 0, 1];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 1, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3Da has different length", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0];
      const dot3Db = [0, 1, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3Db has different length", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 1, 0, 1];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when all inputs have inconsistent lengths", () => {
      const dot3D = [1, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [0, 1];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid input - duplicate points", () => {
    test("should return empty array when dot3D equals dot3Da", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [1, 2, 3];
      const dot3Db = [4, 5, 6];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D equals dot3Db", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [4, 5, 6];
      const dot3Db = [1, 2, 3];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3Da equals dot3Db", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 2, 3];
      const dot3Db = [1, 2, 3];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when all three points are the same", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [1, 2, 3];
      const dot3Db = [1, 2, 3];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid input - collinear points", () => {
    test("should return empty array when three points are collinear on X axis", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 0, 0];
      const dot3Db = [2, 0, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when three points are collinear on Y axis", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0, 1, 0];
      const dot3Db = [0, 3, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when three points are collinear on diagonal", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 1, 1];
      const dot3Db = [2, 2, 2];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when three points are collinear with offset", () => {
      const dot3D = [1, 2, 3];
      const dot3Da = [2, 4, 6];
      const dot3Db = [3, 6, 9];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Edge cases", () => {
    test("should handle points with very small distances", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [0.001, 0, 0];
      const dot3Db = [0, 0.001, 0];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(1);
      expect(result[3]).toBeCloseTo(0);
    });

    test("should handle points with large coordinates", () => {
      const dot3D = [1000, 2000, 3000];
      const dot3Da = [1001, 2000, 3000];
      const dot3Db = [1000, 2001, 3000];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,0,0] and [0,1,0]
      // Cross product = [0,0,1]
      // d = -(0*1000 + 0*2000 + 1*3000) = -3000
      expect(result[0]).toBeCloseTo(0);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(1);
      expect(result[3]).toBeCloseTo(-3000);
    });

    test("should handle points forming a tilted plane", () => {
      const dot3D = [0, 0, 0];
      const dot3Da = [1, 1, 1];
      const dot3Db = [1, 0, 1];
      const result = gemm.plane3D_3dots(dot3D, dot3Da, dot3Db);
      // Vectors: [1,1,1] and [1,0,1]
      // Cross product = [1*1 - 1*0, 1*1 - 1*1, 1*0 - 1*1] = [1,0,-1]
      // Norm = sqrt(2)
      // Normalized = [1/sqrt(2), 0, -1/sqrt(2)]
      const norm = Math.sqrt(2);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(0);
      expect(result[2]).toBeCloseTo(-1 / norm);
      expect(result[3]).toBeCloseTo(0);
    });
  });

});
