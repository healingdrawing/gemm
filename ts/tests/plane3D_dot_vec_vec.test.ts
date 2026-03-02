// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

/**
 * Test suite for plane3D_dot_vec_vec function using Bun's built-in test runner
 * Tests 3D plane equation calculation from a point and two non-parallel vectors
 * The normal vector is computed as the cross product of the two input vectors
 * Where (a, b, c) is the normal vector and d is the displacement from origin
 */

describe("plane3D_dot_vec_vec", () => {
  describe("Valid plane calculations with standard basis vectors", () => {
    test("should calculate plane from point [0,0,0] and vectors [1,0,0] and [0,1,0]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,0,0] x [0,1,0] = [0,0,1]
      expect(result).toEqual([0, 0, 1, -0]);
    });

    test("should calculate plane from point [1,1,1] and vectors [1,0,0] and [0,1,0]", () => {
      const dot3D = [1, 1, 1];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,0,0] x [0,1,0] = [0,0,1], d = -(0*1 + 0*1 + 1*1) = -1
      expect(result).toEqual([0, 0, 1, -1]);
    });

    test("should calculate plane from point [0,0,0] and vectors [1,0,0] and [0,0,1]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 0, 1];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,0,0] x [0,0,1] = [0,-1,0]
      expect(result).toEqual([0, -1, 0, -0]);
    });

    test("should calculate plane from point [0,0,0] and vectors [0,1,0] and [0,0,1]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [0, 1, 0];
      const vec3Db = [0, 0, 1];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [0,1,0] x [0,0,1] = [1,0,0]
      expect(result).toEqual([1, 0, 0, -0]);
    });
  });

  describe("Valid plane calculations with arbitrary vectors", () => {
    test("should calculate plane from point [1,2,3] and vectors [1,1,0] and [0,1,1]", () => {
      const dot3D = [1, 2, 3];
      const vec3Da = [1, 1, 0];
      const vec3Db = [0, 1, 1];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,1,0] x [0,1,1] = [1,-1,1]
      // Norm of [1,-1,1] = sqrt(1 + 1 + 1) = sqrt(3)
      // Normalized: [1/sqrt(3), -1/sqrt(3), 1/sqrt(3)]
      // d = -(1/sqrt(3)*1 + (-1/sqrt(3))*2 + 1/sqrt(3)*3) = -2/sqrt(3)
      const norm = Math.sqrt(3);
      expect(result[0]).toBeCloseTo(1 / norm);
      expect(result[1]).toBeCloseTo(-1 / norm);
      expect(result[2]).toBeCloseTo(1 / norm);
      expect(result[3]).toBeCloseTo(-2 / norm);
    });

    test("should calculate plane from point [0,0,0] and vectors [2,0,0] and [0,3,0]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [2, 0, 0];
      const vec3Db = [0, 3, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [2,0,0] x [0,3,0] = [0,0,6]
      // Norm of [0,0,6] = 6
      // Normalized: [0, 0, 1]
      // d = -(0*0 + 0*0 + 1*0) = -0 //warning yes, facepalm
      expect(result).toEqual([0, 0, 1, -0]);
    });

    test("should calculate plane from point [1,0,0] and vectors [1,1,1] and [1,-1,0]", () => {
      const dot3D = [1, 0, 0];
      const vec3Da = [1, 1, 1];
      const vec3Db = [1, -1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,1,1] x [1,-1,0] = [1,1,-2]
      // d = -(1*1 + 1*0 + (-2)*0) = -1
      const norm = Math.sqrt(6);
  expect(result).toEqual([
    1 / norm,
    1 / norm,
    -2 / norm,
    -1 / norm
  ]);
    });

    test("should handle negative vector components", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [-1, 0, 0];
      const vec3Db = [0, -1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([0, 0, 1, -0]);
    });
  });

  describe("Invalid input - wrong array lengths", () => {
    test("should return empty array when dot3D has length 2", () => {
      const dot3D = [1, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when dot3D has length 4", () => {
      const dot3D = [1, 0, 0, 1];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3Da has length 2", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3Db has length 4", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0, 1];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when all inputs have wrong lengths", () => {
      const dot3D = [1, 0];
      const vec3Da = [1, 0];
      const vec3Db = [0, 1];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid input - zero vectors", () => {
    test("should return empty array when vec3Da is zero vector [0,0,0]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [0, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vec3Db is zero vector [0,0,0]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 0, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when both vectors are zero", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [0, 0, 0];
      const vec3Db = [0, 0, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Invalid input - parallel vectors", () => {
    test("should return empty array when vectors are parallel [1,0,0] and [2,0,0]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 0, 0];
      const vec3Db = [2, 0, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vectors are parallel [1,1,1] and [2,2,2]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1, 1, 1];
      const vec3Db = [2, 2, 2];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vectors are antiparallel [1,0,0] and [-3,0,0]", () => {
      const dot3D = [1, 2, 3];
      const vec3Da = [1, 0, 0];
      const vec3Db = [-3, 0, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });

    test("should return empty array when vectors are scalar multiples [2,4,6] and [1,2,3]", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [2, 4, 6];
      const vec3Db = [1, 2, 3];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([]);
    });
  });

  describe("Edge cases", () => {
    test("should handle very small non-parallel vectors", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [0.001, 0, 0];
      const vec3Db = [0, 0.001, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result[2]).toBeCloseTo(1);
    });

    test("should handle large vector magnitudes", () => {
      const dot3D = [0, 0, 0];
      const vec3Da = [1000, 0, 0];
      const vec3Db = [0, 1000, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      expect(result).toEqual([0, 0, 1, -0]);
    });

    test("should handle point not on plane through origin", () => {
      const dot3D = [5, 10, 15];
      const vec3Da = [1, 0, 0];
      const vec3Db = [0, 1, 0];
      const result = gemm.plane3D_dot_vec_vec(dot3D, vec3Da, vec3Db);
      // Cross product [1,0,0] x [0,1,0] = [0,0,1]
      // d = -(0*5 + 0*10 + 1*15) = -15
      expect(result).toEqual([0, 0, 1, -15]);
    });
  });

});
