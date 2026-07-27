// @ts-nocheck
// ts/terminal.test.ts — CLI bridge for Zig cross-checks
// Usage: bun ts/terminal.test.ts <method> <args...>
// Example: bun ts/terminal.test.ts v3v3scalar 1 2 3 4 5 6
// stdout: one result line only

import { GEMM } from "./gemm";

const gemm = new GEMM();

type Handler = (args: number[]) => number | number[];

const methods: Record<string, Handler> = {
  v3v3scalar: (a) => {
    if (a.length !== 6) throw new Error("v3v3scalar needs 6 numbers");
    return gemm.v3v3scalar(
      new Float32Array([a[0], a[1], a[2]]),
      new Float32Array([a[3], a[4], a[5]]),
    );
  },
  // v3v3cross: (a) => { ... },
};

const [method, ...rest] = process.argv.slice(2);

if (!method) {
  console.error("Usage: bun ts/terminal.test.ts <method> <args...>");
  process.exit(2);
}

const fn = methods[method];
if (!fn) {
  console.error(`unknown method: ${method}`);
  process.exit(2);
}

const nums = rest.map((s) => {
  const n = Number(s);
  if (Number.isNaN(n)) throw new Error(`not a number: ${s}`);
  return n;
});

try {
  const out = fn(nums);
  if (typeof out === "number") {
    console.log(String(out));
  } else {
    console.log(out.join(" "));
  }
} catch (e) {
  console.error(e instanceof Error ? e.message : e);
  process.exit(1);
}