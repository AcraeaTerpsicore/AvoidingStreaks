# Streak Avoidance Toolkit (Mathematica/Wolfram Language)

This project implements the key constructions from `reference_paper/main.tex` directly in Wolfram Language. It focuses on enumerating $n$-ary words that avoid either strictly increasing streaks of length $k$ or their non-decreasing (``soft'') counterparts, together with the expected waiting times and asymptotic formulas from the [paper](https://arxiv.org/abs/2511.13287).

## Layout
- `src/Streaks.wl` – main package containing implementations of $\psi_{k,r}$, the Goulden–Jackson weights, generating functions, waiting-time formulas, and helpers for brute-force verification.
- `tests/run_tests.wls` – automated test suite executed with `wolframscript`.
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

## Minimal forbidden set utilities
- `MinimalForbiddenGeneratingFunction[n,k]` returns the rational function $\dfrac{1+z+\cdots+z^{k-1}}{1-(n-1)(z+z^2+\cdots+z^k)}$ coming from the minimal forbidden set $\{(1,1,\ldots,1)\}$ described in Proposition 8.1.
- `MinimalForbiddenDenominator[n,k,z]` exposes the denominator directly, making it easy to study where it stays positive.
- `MinimalForbiddenRadiusLowerBound[n,k]` evaluates the denominator at $z=\frac{1}{n}$; the positive result certifies the strict $> \frac{1}{n}$ lower bound for the radius of convergence from Section 8.

## Future Extensions
- [ ] **General Goulden–Jackson engine**  
  Status: Not started — Extend `Streaks.wl` with a full implementation of the cluster/overlap linear system from Sections 3–4 so arbitrary forbidden sets $\Fs$ (not only streaks) can be enumerated by solving for all $W(\vb{a})$ and the resulting generating function.
- [ ] **Random-sampling verification tools**  
  Status: Not started — Build Monte Carlo samplers inspired by Section 6 to empirically estimate the waiting time for (soft) streaks and compare the averages with `ExpectedDrawsToStreak` / `SoftStreakExpectedDraws`.
