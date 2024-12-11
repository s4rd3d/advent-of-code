const fs = require("fs");

// Cache for operation results
const cache = {};

// Precompute powers of 10 to avoid repetitive Math.pow calls
const powersOf10 = Array.from({ length: 20 }, (_, i) => Math.pow(10, i));

function solve(input, iterations) {
    // Use a Map to track counts of each unique number
    let counts = new Map();

    // Initialize counts from input
    for (const num of input) {
        counts.set(num, (counts.get(num) || 0) + 1);
    }

    for (let i = 0; i < iterations; i++) {
        const newCounts = new Map();

        for (const [num, count] of counts.entries()) {
            const result = operation(num);

            if (Array.isArray(result)) {
                for (const r of result) {
                    newCounts.set(r, (newCounts.get(r) || 0) + count);
                }
            } else {
                newCounts.set(result, (newCounts.get(result) || 0) + count);
            }
        }

        counts = newCounts; // Update counts for the next iteration
    }

    // Total length is the sum of all counts
    return Array.from(counts.values()).reduce((sum, count) => sum + count, 0);
}

function operation(n) {
    if (cache[n] !== undefined) {
        return cache[n];
    }
    if (n === 0) {
        cache[n] = 1;
        return 1;
    }
    const digits = Math.floor(Math.log10(n)) + 1;
    if (digits % 2 !== 0) {
        const res = n * 2024;
        cache[n] = res;
        return res;
    }
    const divisor = powersOf10[digits / 2];
    const firstHalf = Math.floor(n / divisor);
    const secondHalf = n % divisor;
    const result = [firstHalf, secondHalf];
    cache[n] = result;
    return result;
}

// Read input
const input = fs.readFileSync("input", "utf-8").trim().split(" ").map(Number);
console.log(solve(input, 25));
console.log(solve(input, 75));
