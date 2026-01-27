// Intentionally contains irregular whitespace characters.
// NBSP (U+00A0), ZWSP (U+200B), NNBSP (U+202F), mid-line BOM (U+FEFF).

const alpha = 1;          // NBSP between 'const' and 'alpha'
const beta​= 2;          // ZWSP before '='
const sum = alpha  + beta; // NNBSP before '+'
const gamma = 3;         // Trailing NBSP
let delta﻿ = 4;          // mid-line BOM
let ​  mix = alpha + beta + gamma + delta; // multiple irregular spaces
console.log(alpha + beta + sum + gamma + delta + mix);
