# Streak Avoidance Toolkit (Mathematica/Wolfram Language)

This project implements the constructions from `reference_paper/main.tex` directly in Wolfram Language.  It focuses on enumerating $n$-ary words that avoid either strictly increasing streaks of length $k$ or their non-decreasing (``soft'') counterparts, together with expected waiting times and asymptotic formulas that appear in the paper.

## Layout
- `src/Streaks.wl` – main package containing implementations of $\psi_{k,r}$, the Goulden–Jackson weights, generating functions, waiting-time formulas, and helpers for brute-force verification.
- `tests/run_tests.wls` – automated test suite executed with `wolframscript`.
- `reference_paper/` – original arXiv source (ignored by Git per the requirements).
- `FORMULAS.md` – key formulas copied from the paper that the implementation relies on.
- `TEST_SUMMARY.md` – human-readable record of the automated tests.

## Using the package
Load the package from a Wolfram Language kernel (Mathematica notebook, `wolframscript`, or `MathKernel`):

```wl
Get["/path/to/src/Streaks.wl"];

(* Count 4-ary words that avoid increasing streaks of length 3 *)
StreakCount[4, 3, 6]

(* Obtain the generating function f_{n,k}(z) and expand it *)
Series[StreakGeneratingFunction[4, 3][z], {z, 0, 6}]

(* Expected number of draws to hit a streak *)
ExpectedDrawsToStreak[6, 4] // N

(* Soft (non-decreasing) streak conjectural generating function *)
SoftStreakGeneratingFunction[3, 3][z] // Series[#, {z, 0, 4}] &
```

Helpers such as `CountWordsWithoutStreak` and `CountWordsWithoutSoftStreak` are provided for brute-force sanity checks on small parameters.

## Running the automated tests
From the repository root run:

```bash
/mnt/d/Software/Wolfram\ Research/Mathematica/14.0/wolframscript.exe -file tests/run_tests.wls
```

All tests should pass with exit code `0`.  See `TEST_SUMMARY.md` for the scenarios that the suite covers.
