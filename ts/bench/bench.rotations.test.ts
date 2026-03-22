// @ts-nocheck
import { describe, test } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM()

/**
 * Benchmark suite comparing v3rotmut vs vec3Drotate performance
 * Running 1000 rotations for each function with identical inputs
 */

describe("Rotation Functions Performance Benchmark", () => {

  describe("Benchmark: 1000 rotations around Z-axis by π/2", () => {
    test("v3rotmut performance", () => {
      const vector = [1, 0, 0];
      const axis = new Float32Array([0, 0, 1]);
      gemm.v3one(axis); // Mutates axis in place, normalizes it
      const angle = Math.PI / 2;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const v = new Float32Array([1, 0, 0]);
        gemm.v3rotmut(v, axis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (1000 iterations): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });

    test("vec3Drotate performance", () => {
      const vector = [1, 0, 0];
      const axis = [0, 0, 1];
      const angle = Math.PI / 2;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        gemm.vec3Drotate([...vector], [...axis], angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (1000 iterations): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });
  });

  describe("Benchmark: 1000 rotations around arbitrary axis by π/4", () => {
    test("v3rotmut performance", () => {
      const rawAxis = new Float32Array([1, 2, 3]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place, normalizes it
      const angle = Math.PI / 4;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const v = new Float32Array([5, 7, 2]);
        gemm.v3rotmut(v, rawAxis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (1000 iterations, arbitrary axis): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });

    test("vec3Drotate performance", () => {
      const vector = [5, 7, 2];
      const axis = [1, 2, 3];
      const angle = Math.PI / 4;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        gemm.vec3Drotate([...vector], [...axis], angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (1000 iterations, arbitrary axis): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });
  });

  describe("Benchmark: 1000 rotations with varying angles", () => {
    test("v3rotmut performance (variable angles)", () => {
      const rawAxis = new Float32Array([1, 1, 1]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const angle = (i / iterations) * 2 * Math.PI;
        const v = new Float32Array([3, 4, 5]);
        gemm.v3rotmut(v, rawAxis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (1000 iterations, variable angles): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });

    test("vec3Drotate performance (variable angles)", () => {
      const vector = [3, 4, 5];
      const axis = [1, 1, 1];
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const angle = (i / iterations) * 2 * Math.PI;
        gemm.vec3Drotate([...vector], [...axis], angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (1000 iterations, variable angles): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });
  });

  describe("Benchmark: 1000 rotations with varying vectors", () => {
    test("v3rotmut performance (variable vectors)", () => {
      const rawAxis = new Float32Array([0, 1, 0]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place
      const angle = Math.PI / 3;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const scale = (i / iterations) * 10 + 1;
        const v = new Float32Array([scale, scale * 2, scale * 3]);
        gemm.v3rotmut(v, rawAxis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (1000 iterations, variable vectors): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });

    test("vec3Drotate performance (variable vectors)", () => {
      const axis = [0, 1, 0];
      const angle = Math.PI / 3;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const scale = (i / iterations) * 10 + 1;
        const vector = [scale, scale * 2, scale * 3];
        gemm.vec3Drotate(vector, axis, angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (1000 iterations, variable vectors): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });
  });

  describe("Benchmark: 5000 rotations stress test", () => {
    test("v3rotmut stress test (5000 iterations)", () => {
      const rawAxis = new Float32Array([1, 0, 1]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place
      const angle = Math.PI / 6;
      const iterations = 5000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const v = new Float32Array([1, 2, 3]);
        gemm.v3rotmut(v, rawAxis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (5000 iterations): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
      console.log(`  Throughput: ${(iterations / (duration / 1000)).toFixed(0)} rotations/sec`);
    });

    test("vec3Drotate stress test (5000 iterations)", () => {
      const vector = [1, 2, 3];
      const axis = [1, 0, 1];
      const angle = Math.PI / 6;
      const iterations = 5000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        gemm.vec3Drotate([...vector], [...axis], angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (5000 iterations): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
      console.log(`  Throughput: ${(iterations / (duration / 1000)).toFixed(0)} rotations/sec`);
    });
  });

  describe("Benchmark: 1000 rotations with pre-normalized axis (fair comparison)", () => {
    test("v3rotmut with pre-normalized axis", () => {
      const rawAxis = new Float32Array([2, 3, 1]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place, normalizes it
      const angle = Math.PI / 5;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        const v = new Float32Array([7, 3, 5]);
        gemm.v3rotmut(v, rawAxis, angle);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`\n✓ v3rotmut (pre-normalized axis): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });

    test("vec3Drotate with pre-normalized axis (fair comparison)", () => {
      const rawAxis = new Float32Array([2, 3, 1]);
      gemm.v3one(rawAxis); // Mutates rawAxis in place, normalizes it
      const angle = Math.PI / 5;
      const iterations = 1000;

      const start = performance.now();
      
      for (let i = 0; i < iterations; i++) {
        gemm.vec3Drotate([7, 3, 5], Array.from(rawAxis), angle, true);
      }
      
      const end = performance.now();
      const duration = end - start;
      
      console.log(`✓ vec3Drotate (pre-normalized axis): ${duration.toFixed(3)}ms`);
      console.log(`  Average per rotation: ${(duration / iterations).toFixed(4)}ms`);
    });
  });

});
