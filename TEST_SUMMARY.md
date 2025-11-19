# TEST SUMMARY

- **Command**: `/mnt/d/Software/Wolfram\ Research/Mathematica/14.0/wolframscript.exe -file tests/run_tests.wls`
- **Status**: Pass (exit code `0`)

## Coverage
- Verified the periodic weight $\psi_{k,r}$ for representative residues, including negative arguments.
- Matched `StreakCount` against brute-force enumeration for $(n,k)=(3,3)$ and lengths $s\le 4$.
- Confirmed the equivalence between the direct and root-of-unity forms of $f_{n,k}(z)$ and its evaluation at $z=1/n$ for the expected waiting time.
- Tested the generalized binomial coefficient $\mathcal{B}(n,k,r)$ against explicit coefficient extraction.
- Checked the minimal forbidden set utilities: rational generating function equality, the denominator identity $q(1/n)=n^{-k}$, and the positive radius witness returned by `MinimalForbiddenRadiusLowerBound`.
- Checked the conjectured soft-streak generating function (and its alternative expression) numerically, including coefficient-by-coefficient agreement with brute-force enumeration for $(n,k)=(3,3)$, $s\le 4$.
- Ensured the conjectured soft waiting time equals $f^{\text{soft}}_{n,k}(1/n)$.
- Validated that the continuous-limit expectation matches the large-$n$ limit of the discrete expected waiting time (for $k=3$ within $10^{-8}$).
