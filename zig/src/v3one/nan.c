#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include <string.h>

int main() {
    float result = INFINITY / INFINITY;
    uint32_t bits;
    memcpy(&bits, &result, sizeof(uint32_t));
    
    printf("Result: %f\n", result);
    printf("Bits: 0x%08x\n", bits);
    printf("Sign bit: %d\n", (bits >> 31) & 1);
    
    return 0;
}
