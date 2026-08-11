// Benchmark: Math.fround() overflow detection
// Test: Does Math.fround() correctly map f64 overflow to f32 infinity?

function benchmark() {
  const iterations = 1_000_000;
  
  // Test Case 1: Values that overflow f32 but are valid f64
  const testCases = [
    { x: 1e19, y: 1e19, z: 1e19, label: "1e19 each (overflow)" },
    { x: 1e20, y: 1e20, z: 1e20, label: "1e20 each (large overflow)" },
    { x: 1e18, y: 1e18, z: 1e18, label: "1e18 each (near boundary)" },
    { x: 1e10, y: 1e10, z: 1e10, label: "1e10 each (safe)" },
  ];

  const maxF32 = 3.4028234663852886e38;
  const maxF64 = 1.7976931348623157e308;

  console.log(`Max f32: ${maxF32}`);
  console.log(`Max f64: ${maxF64}`);
  console.log(`f32 Infinity: ${Math.fround(Infinity)}`);
  console.log("---\n");

  for (const testCase of testCases) {
    const { x, y, z, label } = testCase;

    // Compute multisum in f64
    const multisum = x * x + y * y + z * z;

    // Apply Math.fround() to simulate f32 rounding
    const frounded = Math.fround(multisum);

    // Check the validation condition
    const isValid = frounded > 0 && frounded < Infinity;

    // Detailed output
    console.log(`Test: ${label}`);
    console.log(`  x*x + y*y + z*z (f64): ${multisum}`);
    console.log(`  Exceeds max f32? ${multisum > maxF32}`);
    console.log(`  Math.fround() result: ${frounded}`);
    console.log(`  Is Infinity? ${frounded === Infinity}`);
    console.log(`  Validation (mag2 > 0 && mag2 < Infinity): ${isValid}`);
    console.log("");
  }

  // Micro-benchmark: overhead of Math.fround() + validation
  console.log("Performance: 1,000,000 iterations");
  
  let sum1 = 0;
  const start1 = performance.now();
  for (let i = 0; i < iterations; i++) {
    const x = 1e10, y = 1e10, z = 1e10;
    const mag2 = x * x + y * y + z * z;
    if (mag2 > 0 && mag2 < Infinity) sum1++;
  }
  const time1 = performance.now() - start1;

  let sum2 = 0;
  const start2 = performance.now();
  for (let i = 0; i < iterations; i++) {
    const x = 1e10, y = 1e10, z = 1e10;
    const mag2 = Math.fround(x * x + y * y + z * z);
    if (mag2 > 0 && mag2 < Infinity) sum2++;
  }
  const time2 = performance.now() - start2;

  console.log(`Without Math.fround(): ${time1.toFixed(2)}ms (valid count: ${sum1})`);
  console.log(`With Math.fround(): ${time2.toFixed(2)}ms (valid count: ${sum2})`);
  console.log(`Overhead: ${(time2 - time1).toFixed(2)}ms`);
}

benchmark();


// Benchmark: Math.fround() overflow AND underflow detection
// Test: Subnormal numbers, denormalization, underflow in f32

function benchmarkUnderflow() {
  const iterations = 1_000_000;
  
  const minNormalF32 = 1.1754943508222875e-38;  // Smallest normal f32
  const minSubnormalF32 = 1.4012984643820441e-45;  // Smallest subnormal f32
  const maxF32 = 3.4028234663852886e38;
  
  console.log(`=== F32 Floating-Point Boundaries ===`);
  console.log(`Min normal f32: ${minNormalF32}`);
  console.log(`Min subnormal f32: ${minSubnormalF32}`);
  console.log(`Max f32: ${maxF32}`);
  console.log(`Math.fround(minSubnormalF32): ${Math.fround(minSubnormalF32)}`);
  console.log(`Math.fround(0): ${Math.fround(0)}`);
  console.log(`Math.fround(-0): ${Math.fround(-0)}`);
  console.log("\n");

  // Test Cases: Underflow and subnormal scenarios
  const testCases = [
    // UNDERFLOW CASES (very tiny numbers)
    { 
      x: 1e-20, y: 1e-20, z: 1e-20, 
      label: "1e-20 each (subnormal squared)" 
    },
    { 
      x: 1e-25, y: 1e-25, z: 1e-25, 
      label: "1e-25 each (deep subnormal)" 
    },
    { 
      x: 1e-200, y: 1e-200, z: 1e-200, 
      label: "1e-200 each (extreme underflow)" 
    },
    { 
      x: Number.MIN_VALUE, y: Number.MIN_VALUE, z: Number.MIN_VALUE, 
      label: `Number.MIN_VALUE each (${Number.MIN_VALUE})` 
    },
    { 
      x: Number.MIN_VALUE / 2, y: 0, z: 0, 
      label: `Near zero: ${Number.MIN_VALUE / 2}` 
    },
    { 
      x: 0, y: 0, z: 0, 
      label: "Zero case" 
    },
    // NORMAL CASES for reference
    { 
      x: 1, y: 1, z: 1, 
      label: "1 each (normalized)" 
    },
    { 
      x: 1e10, y: 1e10, z: 1e10, 
      label: "1e10 each (safe)" 
    },
  ];

  console.log(`=== Detailed Test Cases ===\n`);

  for (const testCase of testCases) {
    const { x, y, z, label } = testCase;

    // Compute multisum in f64
    const multisum = x * x + y * y + z * z;

    // Apply Math.fround()
    const frounded = Math.fround(multisum);

    // Validation checks
    const isValid = frounded > 0 && frounded < Infinity;
    const isZero = frounded === 0 || frounded === -0;
    const isSubnormal = frounded !== 0 && Math.abs(frounded) < minNormalF32;
    const isInfinity = !isFinite(frounded);

    console.log(`Test: ${label}`);
    console.log(`  Input: x=${x}, y=${y}, z=${z}`);
    console.log(`  x*x + y*y + z*z (f64): ${multisum}`);
    console.log(`  Math.fround() result: ${frounded}`);
    console.log(`  Bits: ${frounded.toString(2) || "0"}`);
    console.log(`  Zero? ${isZero}`);
    console.log(`  Subnormal? ${isSubnormal}`);
    console.log(`  Infinity? ${isInfinity}`);
    console.log(`  Validation (mag2 > 0 && mag2 < Infinity): ${isValid}`);
    console.log("");
  }

  // Performance benchmark: Detection overhead
  console.log(`=== Performance: 1,000,000 iterations ===\n`);

  let sum1 = 0;
  const start1 = performance.now();
  for (let i = 0; i < iterations; i++) {
    const x = 1e-25, y = 1e-25, z = 1e-25;
    const mag2 = x * x + y * y + z * z;
    if (mag2 > 0 && mag2 < Infinity) sum1++;
  }
  const time1 = performance.now() - start1;

  let sum2 = 0;
  const start2 = performance.now();
  for (let i = 0; i < iterations; i++) {
    const x = 1e-25, y = 1e-25, z = 1e-25;
    const mag2 = Math.fround(x * x + y * y + z * z);
    if (mag2 > 0 && mag2 < Infinity) sum2++;
  }
  const time2 = performance.now() - start2;

  console.log(`Without Math.fround() (1e-25 case): ${time1.toFixed(2)}ms`);
  console.log(`With Math.fround() (1e-25 case): ${time2.toFixed(2)}ms`);
  console.log(`Overhead: ${(time2 - time1).toFixed(2)}ms\n`);

  // Edge case: What happens with mixed magnitudes?
  console.log(`=== Mixed Magnitude Case ===\n`);
  const mixed_x = 1e-25;
  const mixed_y = 1e10;
  const mixed_z = 1e-30;
  const mixed_sum = mixed_x * mixed_x + mixed_y * mixed_y + mixed_z * mixed_z;
  const mixed_frounded = Math.fround(mixed_sum);
  console.log(`x=${mixed_x}, y=${mixed_y}, z=${mixed_z}`);
  console.log(`Sum: ${mixed_sum}`);
  console.log(`Math.fround(): ${mixed_frounded}`);
  console.log(`Valid? ${mixed_frounded > 0 && mixed_frounded < Infinity}\n`);
}

benchmarkUnderflow();