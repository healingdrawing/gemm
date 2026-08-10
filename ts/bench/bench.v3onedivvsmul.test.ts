// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

function v3one_div(v3: Float32Array){
  const mag = Math.sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])
    if (mag > 0){
      v3[0] /= mag
      v3[1] /= mag
      v3[2] /= mag
    }
}

function v3one_mul(v3: Float32Array){
  const mag = Math.sqrt(v3[0]*v3[0] + v3[1]*v3[1] + v3[2]*v3[2])
    if (mag > 0){
      const inv = 1/mag
      v3[0] *= mag
      v3[1] *= mag
      v3[2] *= mag
    }
}

describe("v3one vs vecXDone", () => {
  const v3 = new Float32Array([1, 2, 3]);
  const v3copy = new Float32Array(3); // pre-allocated

  describe("Benchmark 10000 runs", () => {
    test("normalize performance", () => {
      // warmup, since first always slower
      for (let i = 0; i < 10000; i++) {
        v3copy.set(v3);
        v3one_div(v3);
      }
      
      for (let i = 0; i < 10000; i++) {
        v3copy.set(v3);
        v3one_mul(v3);
      }

      const start1 = performance.now();
      for (let i = 0; i < 100000; i++) {
        v3copy.set(v3);        // fast copy
        v3one_div(v3);
      }
      const time1 = performance.now() - start1;

      const start2 = performance.now();
      for (let i = 0; i < 100000; i++) {
        v3copy.set(v3);
        v3one_mul(v3copy);
      }
      const time2 = performance.now() - start2;

      console.log(`${time1.toFixed(2)} ms 10000 runs: v3one_div`);
      console.log(`${time2.toFixed(2)} ms 10000 runs: v3one_mul`);
    });
  });
});
