// @ts-nocheck
// ts/terminalcall.ts — CLI bridge for Zig cross-checks
// Usage: bun ts/terminalcall.ts <method> <args...>
// Example: bun ts/terminalcall.ts v3v3scalar 1 2 3 4 5 6
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
  v3one: (a) => {
    if (a.length !== 3) throw new Error("v3one needs 3 numbers");
    const v3 = new Float32Array([a[0], a[1], a[2]]);
    gemm.v3one( v3 );
    return v3;
  },
  v3rot: (a) => {
    if (a.length !== 7) throw new Error("v3rot needs 7 numbers");
    const v3 = new Float32Array([a[0], a[1], a[2]]);
    const naxis = new Float32Array([a[3], a[4], a[5]]);
    const angle = a[6]
    gemm.v3rot( v3, naxis, angle );
    return v3;
  },
  v3mag2: (a) => {
    if (a.length !== 3) throw new Error("v3mag2 needs 3 numbers");
    return gemm.v3mag2(new Float32Array([a[0], a[1], a[2]]));
  },
  v3mag: (a) => {
    if (a.length !== 3) throw new Error("v3mag needs 3 numbers");
    return gemm.v3mag(new Float32Array([a[0], a[1], a[2]]));
  },
  v3ok: (a) => {
    if (a.length !== 3) throw new Error("v3ok needs 3 numbers");
    return gemm.v3ok(new Float32Array([a[0], a[1], a[2]]));
  },
  v3back: (a) => {
    if (a.length !== 3) throw new Error("v3back needs 3 numbers");
    const v3 = new Float32Array([a[0], a[1], a[2]]);
    gemm.v3back(v3);
    return v3;
  },
  v3v3same: (a) => {
    if (a.length !== 6) throw new Error("v3v3same needs 6 numbers");
    return gemm.v3v3same(
      new Float32Array([a[0], a[1], a[2]]),
      new Float32Array([a[3], a[4], a[5]]),
    );
  },
  v3v3similar: (a) => {
    if (a.length !== 6) throw new Error("v3v3similar needs 6 numbers");
    return gemm.v3v3similar(
      new Float32Array([a[0], a[1], a[2]]),
      new Float32Array([a[3], a[4], a[5]]),
    );
  },
  v3v3cos: (a) => {
    if (a.length !== 6) throw new Error("v3v3cos needs 6 numbers");
    return gemm.v3v3cos(
      new Float32Array([a[0], a[1], a[2]]),
      new Float32Array([a[3], a[4], a[5]]),
    );
  },
  v3v3angle: (a) => {
    if (a.length !== 6) throw new Error("v3v3angle needs 6 numbers");
    return gemm.v3v3angle(
      new Float32Array([a[0], a[1], a[2]]),
      new Float32Array([a[3], a[4], a[5]]),
    );
  },
  // v3v3cross: (a) => { ... },
};

const [method, ...rest] = process.argv.slice(2);

if (!method) {
  console.error("Usage: bun ts/terminalcall.ts <method> <args...>");
  process.exit(2);
}

const fn = methods[method];
if (!fn) {
  console.error(`unknown method: ${method}`);
  process.exit(2);
}

const nums = rest.map((s) => {
  if (s === "NaN") return NaN;
  if (s === "Infinity") return Infinity;
  if (s === "-Infinity") return -Infinity;
  const n = Number(s);
  if (Number.isNaN(n)) throw new Error(`not a number: ${s}`);
  return n;
});

try {
  const out = fn(nums);
  // patch for boolean result true false -> 1 0 between ts and zig to solidify to numbers only
  if ( typeof out === "boolean") console.log(out?1:0)
  else if (typeof out === "number") {
    console.log(float_to_string(out));
  } else {
    console.log(Array.from(out).map(float_to_string).join(" "));
  }
} catch (e) {
  console.error(e instanceof Error ? e.message : e);
  process.exit(1);
}

function float_to_string(val: number): string {
  if (Number.isNaN(val)) {
    return "NaN";
  } else if (!Number.isFinite(val)) {
    return val > 0 ? "Infinity" : "-Infinity";
  } else {
    return String(val);
  }
}
