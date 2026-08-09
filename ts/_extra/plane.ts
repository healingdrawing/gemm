//todo remove later. raw test/reminder
import { GEMM } from "../gemm";
const gemm= new GEMM()
const d3 = [6, 6, 6] as unknown as Float32Array;
const p31 = [1, 1, 1, 9] as unknown as Float32Array;
const p32 = [10, 10, 10, 9] as unknown as Float32Array;
console.log(gemm.distance_d3_p3(d3, p31))
console.log(gemm.distance_d3_p3(d3, p32))
// in case of scale of the plane (maybe to rebalance number or so) the d must be scaled too
const v = [Infinity, 1, 1] as unknown as Float32Array;
gemm.v3one(v);
console.log(v);

let vok = [Infinity, -Infinity, 0] as unknown as Float32Array;
const fv = gemm.v3ok(vok);
console.log(fv);

let vok2 = [0.0000000000000000000000000000000000000001, 0, 0] as unknown as Float32Array;
const fv2 = gemm.v3ok(vok2);
console.log(fv2);

let v3a = [Infinity, NaN, 0] as unknown as Float32Array;
let v3b = [Infinity, NaN, 0] as unknown as Float32Array;
const r3 = gemm.v3v3similar(v3a, v3b);
console.log("Math.abs(v3a[1] - v3b[1])", Math.abs(v3a[1] - v3b[1]))
console.log("wtf NaN === NaN", v3a[1], v3b[1], v3a[1] === v3b[1])
console.log(v3a, v3b, r3)