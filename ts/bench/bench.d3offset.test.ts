// @ts-nocheck
import { test, expect, describe } from "bun:test";
import { GEMM } from "../gemm";
const gemm = new GEMM();

describe("offset functions benchmark & equivalence", () => {

  // ────────────────────────────────
  // Benchmark – time only
  // ────────────────────────────────

  test("benchmark – 10 000 offsets", () => {
    const dot  = [10, 20, 30];
    const vec  = [1, -2, 4];
    const d3   = new Float32Array([10, 20, 30]);
    const v3   = new Float32Array([1, -2, 4]);
    const t    = 2.5;

    const WARMUP = 1000;
    const N      = 10000;

    // warmup
    for (let i = 0; i < WARMUP; i++) {
      gemm.dotXDoffset(dot, vec, t);
      gemm.d3offset_mut(d3, v3, t);
    }

    // dotXDoffset
    const t1 = performance.now();
    for (let i = 0; i < N; i++) {
      gemm.dotXDoffset(dot, vec, t);
    }
    const ms1 = performance.now() - t1;

    // d3offset_mut
    const t2 = performance.now();
    for (let i = 0; i < N; i++) {
      gemm.d3offset_mut(d3, v3, t);
    }
    const ms2 = performance.now() - t2;

    console.log(`offset 10 000 ×`);
    console.log(`dotXDoffset     ${ms1.toFixed(1)} ms`);
    console.log(`d3offset_mut    ${ms2.toFixed(1)} ms`);
    console.log("");
  });

  // ────────────────────────────────
  // Correctness – equivalence check
  // ────────────────────────────────

  describe("d3offset_mut should match dotXDoffset result", () => {
    const cases = [
      { d: [0,0,0],   v: [1,0,0],   t: 5    },
      { d: [7,2,-1],  v: [3,-4,12], t: 0.5  },
      { d: [1,1,1],   v: [-1,2,0],  t: -2   },
      { d: [10,20,30],v: [0,0,0],   t: 999  },
    ];

    for (const c of cases) {
      test(`offset [${c.d}] along [${c.v}] by ${c.t}`, () => {
        const dotCopy = [...c.d];
        const old = gemm.dotXDoffset(dotCopy, c.v, c.t);

        const d3 = new Float32Array(c.d);
        const v3 = new Float32Array(c.v);
        gemm.d3offset_mut(d3, v3, c.t);
        // console.log("new",d3)
        // console.log("old",old)

        expect([...d3]).toEqual(old.map(x => expect.closeTo(x, 6)));
      });
    }
  });

});
