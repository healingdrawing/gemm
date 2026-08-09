grok conversation generated

**Compact notes: data in/out of functions**  
Priority: **1. speed (in/out)** → **2. RAM efficiency**

### TypeScript
Always prefer **reference + mutate** for anything non-scalar.  
Avoid new objects/arrays when possible.

- **Mutate** (fastest)  
  ```ts
  function invert6(a: Float32Array, b: Float32Array, c: Float32Array,
                   d: Float32Array, e: Float32Array, f: Float32Array): void
  ```

- **Return** (tiny scalars only)  
  ```ts
  function sum6(a: number, b: number, c: number, d: number, e: number, f: number): number
  ```

- Multiple values → mutate several refs **or** return plain object only if tiny & rare.

### Zig
Params immutable. Compiler may pass small values in registers or hide a pointer (PRO).  
x86-64 typical: **6 integer/pointer regs**, **8 float/SIMD regs** (XMM0-7).

**Size cheat-sheet (by value still ok, max without spill)**  
| Type              | Bytes | Notes                          |
|-------------------|-------|--------------------------------|
| f32 / i32         | 4     | free (register)                |
| f64 / i64         | 8     | free                           |
| @Vector(4, f32)   | 16    | 1 XMM, no stack                |
| @Vector(2, f64)   | 16    | 1 XMM, no stack                |
| @Vector(8, f32)   | 32    | often 2 regs, still ok         |
| @Vector(4, f64)   | 32    | borderline                     |
| > ~32-64 B        | —     | treat as **big** → pointer     |

**Rules + signatures**

- **≤ 6 params**, each max safe size → pass **by value**  
  ```zig
  fn add6(a: @Vector(4, f32), b: @Vector(4, f32), c: @Vector(4, f32),
          d: @Vector(4, f32), e: @Vector(4, f32), f: @Vector(4, f32)) @Vector(4, f32)
  ```

- **> 6 params** → keep first, pack excess into struct/@Vector (still by value)  
  ```zig
  const Extra = struct { f: @Vector(4, f32), g: @Vector(4, f32) };
  fn add7(a: @Vector(4, f32), b: @Vector(4, f32), c: @Vector(4, f32),
          d: @Vector(4, f32), e: @Vector(4, f32), extra: Extra) @Vector(4, f32)
  ```
  ```zig
  const Tail = struct { f: @Vector(4, f32), g: @Vector(4, f32), h: @Vector(4, f32) };
  fn add8(a: @Vector(4, f32), b: @Vector(4, f32), c: @Vector(4, f32),
          d: @Vector(4, f32), e: @Vector(4, f32), tail: Tail) @Vector(4, f32)
  ```

- **Big data** (runtime arrays, buffers, ≥ ~64 B) → pointer / slice  
  ```zig
  fn process6(a: []f32, b: []f32, c: []f32, d: []f32, e: []f32, f: []f32) void
  ```

- **Mutation** (prefer pointers, up to 6)  
  ```zig
  fn update6(a: *@Vector(4, f32), b: *@Vector(4, f32), c: *@Vector(4, f32),
             d: *@Vector(4, f32), e: *@Vector(4, f32), f: *@Vector(4, f32)) void
  ```
  ```zig
  // >6 mutable → pack excess
  const Extra = struct { f: @Vector(4, f32), g: @Vector(4, f32) };
  fn update7(a: *@Vector(4, f32), b: *@Vector(4, f32), c: *@Vector(4, f32),
             d: *@Vector(4, f32), e: *@Vector(4, f32), extra: *Extra) void
  ```

- **Pure + tiny** → by value + return struct (only while everything stays small)  
  ```zig
  const Result = struct { a: @Vector(4, f32), b: @Vector(4, f32) };
  fn pure2(x: @Vector(4, f32), y: @Vector(4, f32)) Result
  ```

**Quick choice**
```
mutate (≤6)          → *params
mutate (>6)          → *params + *Extra / *Tail
pure + tiny (≤16-32B)→ by value (≤6) + return
>6 params            → keep first, pack tail into struct/@Vector (by value)
big buffer           → slice / pointer (≤6)
```

**Return values (add to rules)**

- **Light return** (stays in register):  
  scalar `f32`/`f64`/`i32`/`i64` or small `@Vector` (≤16 B, ideally `@Vector(4,f32)` / `@Vector(2,f64)`)  
  → returned in **XMM0** (float/SIMD) or **RAX** (integer)

- **Heavy return** (uses hidden pointer):  
  anything bigger (~32 B+) or multi-field struct  
  → caller allocates, passes secret pointer, function writes result

**Examples**
```zig
// light
fn add(a: @Vector(4, f32), b: @Vector(4, f32)) @Vector(4, f32)

// heavy
const Result = struct { a: @Vector(4, f32), b: @Vector(4, f32), c: @Vector(4, f32) };
fn compute(...) Result
```

Prefer light returns when possible. For heavy results prefer out-pointer (`*Result`) instead of returning the big struct.