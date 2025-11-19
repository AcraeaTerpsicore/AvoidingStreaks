# FORMULAS

## Periodic weight
- $\psi_{k,r} = \begin{cases} 1 & r \equiv 0 \pmod{k}\\ -1 & r \equiv 1 \pmod{k}\\ 0 & \text{otherwise} \end{cases}$
- $\psi_{k,r} = \dfrac{1}{k}\displaystyle\sum_{s=1}^{k-1} \bigl(1 - \omega_k^{-s}\bigr)\omega_k^{rs}$ with $\omega_k = e^{\tfrac{2\pi i}{k}}$.

## Goulden–Jackson weights for increasing streaks
- $w_m(z) = -z^k \displaystyle\sum_{r=0}^{m-1} \psi_{k,r}\binom{m-1}{r}z^r$ gives the weight of the streak $(m,m+1,\dots,m+k-1)$.
- $W(\mathcal{F}) = -\displaystyle\sum_{r=k}^n \psi_{k,r}\binom{n}{r}z^r$ is the sum of all streak weights of length $k$ inside an $n$-letter alphabet.

## Generating functions for strict streak avoidance
- $f_{n,k}(z) = \dfrac{1}{\displaystyle\sum_{r=0}^n \psi_{k,r} \binom{n}{r} z^r}$.
- $f_{n,k}(z) = \dfrac{k}{\displaystyle\sum_{s=1}^{k-1}\bigl(1-\omega_k^{-s}\bigr)\bigl(1+\omega_k^s z\bigr)^n}$ (root-of-unity average).
- $\mathcal{P}_s(n,k,s) = [z^s]\,f_{n,k}(z)$ counts the streak-free $n$-ary words of length $s$ (implemented via `SeriesCoefficient`).

## Expected waiting time for a strict streak
- $E(n,k) = f_{n,k}\!\left(\dfrac{1}{n}\right) = \dfrac{1}{\displaystyle\sum_{r=0}^n \psi_{k,r}\binom{n}{r}n^{-r}} = \dfrac{k}{\displaystyle\sum_{s=1}^{k-1}\bigl(1-\omega_k^{-s}\bigr)\left(1+\dfrac{\omega_k^s}{n}\right)^n}$.
- The Monte Carlo utility `MonteCarloStreakWaitingTime` repeatedly samples the drawing process and reports $\bar{X}$, $\bar{X}-E(n,k)$, and the relative error to check this identity empirically.

## Soft (non-decreasing) streaks
- Generalized binomial coefficients: $\mathcal{B}(n,k,r) = \displaystyle\sum_{s=0}^{\lfloor r/k \rfloor}(-1)^s \binom{n}{s}\binom{n+r-ks-1}{n-1}$ are the coefficients of $(1+x+\dots+x^{k-1})^n$.
- Conjectured generating function: $f^{\text{soft}}_{n,k}(z) = \dfrac{(1-z^k)^n}{\displaystyle\sum_{r=0}^{(k-1)n} \psi_{k,r}\,\mathcal{B}(n,k,r)z^r}$.
- Alternative expression: $f^{\text{soft}}_{n,k}(z) = \dfrac{k}{\displaystyle\sum_{s=1}^{k-1}\bigl(1-\omega_k^{-s}\bigr)\bigl(1-\omega_k^s z\bigr)^{-n}}$.
- Expected waiting time (conjectural): $E_{\text{soft}}(n,k) = \dfrac{(1-n^{-k})^n}{\displaystyle\sum_{r=0}^{(k-1)n} \psi_{k,r}\,\mathcal{B}(n,k,r)n^{-r}} = \dfrac{k}{\displaystyle\sum_{s=1}^{k-1}\bigl(1-\omega_k^{-s}\bigr)\left(1-\dfrac{\omega_k^s}{n}\right)^{-n}}$.
- `MonteCarloSoftStreakWaitingTime` performs the same sampling experiment for soft streaks and compares the empirical mean with $E_{\textsf{soft}}(n,k)$ from the conjectured formula.

## Continuous limit
- $\mu_k = \displaystyle\frac{k}{\sum_{s=1}^{k-1} e^{\omega_k^s}\bigl(1-\omega_k^{-s}\bigr)}$ is the expected waiting time when letters are drawn from a continuous distribution (the $n\to\infty$ limit of the discrete expectation).
