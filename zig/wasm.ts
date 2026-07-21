import { readFileSync } from "fs";

const wasmBuffer = readFileSync("./zig-out/bin/gemm.wasm");
const wasmModule = await WebAssembly.instantiate(wasmBuffer);
console.log("Exports:", Object.keys(wasmModule.instance.exports));
