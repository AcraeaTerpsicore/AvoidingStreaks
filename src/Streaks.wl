(* ::Package:: *)

BeginPackage["AvoidingStreaks`"];

Psi::usage =
    "Psi[k, r] implements \\!\\(\\*SubscriptBox[\\(psi\\), \\(k, r\\)]\\), the periodic weight that is 1 when r is divisible by k, -1 when r == 1 mod k, and 0 otherwise.";

StreakWeightSeries::usage =
    "StreakWeightSeries[m, k, z] returns w_m(z), the Goulden-Jackson weight assigned to the streak (m,m+1,...,m+k-1) expressed as a polynomial in z.";

TotalStreakWeight::usage =
    "TotalStreakWeight[n, k, z] gives W(F), the total weight of all strictly increasing streaks of length k over an n-letter alphabet, expressed as a polynomial in z.";

StreakGeneratingFunction::usage =
    "StreakGeneratingFunction[n, k] returns a pure function of z representing f_(n,k)(z) = 1 / Sum_{r=0}^n psi_{k,r} Binomial[n,r] z^r.";

StreakGeneratingFunctionAlt::usage =
    "StreakGeneratingFunctionAlt[n, k] returns a pure function of z representing f_(n,k)(z) via the root-of-unity expression involving (1+omega^s z)^n.";

StreakCount::usage =
    "StreakCount[n, k, s] computes P_s(n,k,s), the count of n-ary words of length s that avoid streaks of length k.";

StreakCounts::usage =
    "StreakCounts[n, k, maxS] returns the list of counts for lengths 0..maxS.";

ExpectedDrawsToStreak::usage =
    "ExpectedDrawsToStreak[n, k] evaluates f_(n,k)(1/n) to give the expected number of draws required to observe a streak of length k.";

GeneralizedBinomialB::usage =
    "GeneralizedBinomialB[n, k, r] implements the coefficient B(n,k,r) of x^r in (1+x+...+x^(k-1))^n.";

SoftStreakGeneratingFunction::usage =
    "SoftStreakGeneratingFunction[n, k] returns the conjectured generating function for avoiding soft (non-decreasing) streaks of length k.";

SoftStreakGeneratingFunctionAlt::usage =
    "SoftStreakGeneratingFunctionAlt[n, k] returns the alternate conjectured expression with the root-of-unity average.";

SoftStreakExpectedDraws::usage =
    "SoftStreakExpectedDraws[n, k] evaluates the conjectured generating function at z = 1/n to obtain the expected waiting time for a soft streak.";

ContinuousStreakExpectation::usage =
    "ContinuousStreakExpectation[k] gives the limiting expected waiting time for a streak of length k when the alphabet size tends to infinity, matching the continuous-draw model.";

MinimalForbiddenGeneratingFunction::usage =
    "MinimalForbiddenGeneratingFunction[n, k] returns the generating function f_{M(k)}(z) for the minimal forbidden set { (1,1,...,1) } of size k.";

MinimalForbiddenDenominator::usage =
    "MinimalForbiddenDenominator[n, k, z] returns 1 - (n-1)(z + z^2 + ... + z^k), the denominator that controls the radius-of-convergence lower bound.";

MinimalForbiddenRadiusLowerBound::usage =
    "MinimalForbiddenRadiusLowerBound[n, k] evaluates the denominator at z = 1/n, proving the >1/n radius lower bound.";

MonteCarloStreakWaitingTime::usage =
    "MonteCarloStreakWaitingTime[n, k, opts] empirically estimates the waiting time for a strict streak with uniform sampling; returns an association with the sample mean, deviation, and comparison to ExpectedDrawsToStreak.";

MonteCarloSoftStreakWaitingTime::usage =
    "MonteCarloSoftStreakWaitingTime[n, k, opts] empirically estimates the waiting time for a non-decreasing (soft) streak and compares it against SoftStreakExpectedDraws.";

CountWordsWithoutStreak::usage =
    "CountWordsWithoutStreak[n, k, s] brute-forces the number of n-ary words of length s that avoid a strictly increasing streak of length k (useful for verification).";

CountWordsWithoutSoftStreak::usage =
    "CountWordsWithoutSoftStreak[n, k, s] brute-forces the number of n-ary words of length s that avoid a non-decreasing streak of length k.";

Begin["`Private`"];

ClearAll[Psi];
Psi[k_Integer?Positive, r_Integer] :=
    Module[{mod = Mod[r, k]},
        Which[
            mod == 0, 1,
            mod == 1, -1,
            True, 0
        ]
    ];

ClearAll[omega];
omega[k_Integer?Positive] := Exp[(2 Pi I)/k];

ClearAll[StrictlyIncreasingBlockQ, NonDecreasingBlockQ];
StrictlyIncreasingBlockQ[list_List] := And @@ Thread[Rest[list] > Most[list]];
NonDecreasingBlockQ[list_List] := And @@ Thread[Rest[list] >= Most[list]];

ClearAll[containsPatternQ];
containsPatternQ[list_List, k_Integer?Positive, pred_] :=
    If[k > Length[list], False,
        AnyTrue[Partition[list, k, 1], pred]
    ];

ClearAll[CountWordsWithoutStreak];
CountWordsWithoutStreak[n_Integer?Positive, k_Integer?Positive, s_Integer?NonNegative] :=
    Module[{tuples = Tuples[Range[n], s]},
        Count[tuples, w_ /; !containsPatternQ[w, k, StrictlyIncreasingBlockQ]]
    ];

ClearAll[CountWordsWithoutSoftStreak];
CountWordsWithoutSoftStreak[n_Integer?Positive, k_Integer?Positive, s_Integer?NonNegative] :=
    Module[{tuples = Tuples[Range[n], s]},
        Count[tuples, w_ /; !containsPatternQ[w, k, NonDecreasingBlockQ]]
    ];

ClearAll[StreakWeightSeries];
StreakWeightSeries[m_Integer?Positive, k_Integer?Positive, z_] /; k >= 2 :=
    -z^k*Sum[Psi[k, r]*Binomial[m - 1, r]*z^r, {r, 0, m - 1}];

ClearAll[TotalStreakWeight];
TotalStreakWeight[n_Integer?Positive, k_Integer?Positive, z_] /; k >= 2 :=
    -Sum[Psi[k, r]*Binomial[n, r]*z^r, {r, k, n}];

ClearAll[StreakGeneratingFunction];
StreakGeneratingFunction[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    With[{n0 = n, k0 = k},
        Function[{z},
            1/Sum[Psi[k0, r]*Binomial[n0, r]*z^r, {r, 0, n0}]
        ]
    ];

ClearAll[StreakGeneratingFunctionAlt];
StreakGeneratingFunctionAlt[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    With[{n0 = n, k0 = k},
        Function[{z},
            k0/Sum[(1 - omega[k0]^(-s))*(1 + omega[k0]^s*z)^n0, {s, 1, k0 - 1}]
        ]
    ];

ClearAll[StreakCount];
StreakCount[n_Integer?Positive, k_Integer?Positive, s_Integer?NonNegative] /; k >= 2 :=
    With[{z = Unique["z"], den = Sum[Psi[k, r]*Binomial[n, r]*z^r, {r, 0, n}]},
        SeriesCoefficient[1/den, {z, 0, s}]
    ];

ClearAll[StreakCounts];
StreakCounts[n_Integer?Positive, k_Integer?Positive, maxS_Integer?NonNegative] :=
    Table[StreakCount[n, k, s], {s, 0, maxS}];

ClearAll[ExpectedDrawsToStreak];
ExpectedDrawsToStreak[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    1/Sum[Psi[k, r]*Binomial[n, r]*n^-r, {r, 0, n}];

ClearAll[GeneralizedBinomialB];
GeneralizedBinomialB[n_Integer?NonNegative, k_Integer?Positive, r_Integer?NonNegative] /; k >= 2 :=
    Sum[(-1)^s*Binomial[n, s]*Binomial[n + r - k*s - 1, n - 1], {s, 0, Floor[r/k]}];

ClearAll[SoftStreakGeneratingFunction];
SoftStreakGeneratingFunction[n_Integer?NonNegative, k_Integer?Positive] /; k >= 2 :=
    With[{n0 = n, k0 = k},
        Function[{z},
            (1 - z^k)^n0/
                Sum[Psi[k0, r]*GeneralizedBinomialB[n0, k0, r]*z^r, {r, 0, (k0 - 1)*n0}]
        ]
    ];

ClearAll[SoftStreakGeneratingFunctionAlt];
SoftStreakGeneratingFunctionAlt[n_Integer?NonNegative, k_Integer?Positive] /; k >= 2 :=
    With[{n0 = n, k0 = k},
        Function[{z},
            k0/Sum[(1 - omega[k0]^(-s))*(1 - omega[k0]^s*z)^(-n0), {s, 1, k0 - 1}]
        ]
    ];

ClearAll[SoftStreakExpectedDraws];
SoftStreakExpectedDraws[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    (1 - n^-k)^n/Sum[Psi[k, r]*GeneralizedBinomialB[n, k, r]*n^-r, {r, 0, (k - 1)*n}];

ClearAll[ContinuousStreakExpectation];
ContinuousStreakExpectation[k_Integer?Positive] /; k >= 2 :=
    k/Sum[Exp[omega[k]^s]*(1 - omega[k]^(-s)), {s, 1, k - 1}];

ClearAll[MinimalForbiddenGeneratingFunction];
MinimalForbiddenGeneratingFunction[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    With[{n0 = n, k0 = k},
        Function[{z},
            Module[{num = Sum[z^i, {i, 0, k0 - 1}], den = MinimalForbiddenDenominator[n0, k0, z]},
                num/den
            ]
        ]
    ];

ClearAll[MinimalForbiddenDenominator];
MinimalForbiddenDenominator[n_Integer?Positive, k_Integer?Positive, z_] /; k >= 2 :=
    1 - (n - 1)*Sum[z^i, {i, 1, k}];

ClearAll[MinimalForbiddenRadiusLowerBound];
MinimalForbiddenRadiusLowerBound[n_Integer?Positive, k_Integer?Positive] /; k >= 2 :=
    Module[{z = 1/n},
        <|
            "CandidateBound" -> z,
            "DenominatorAtBound" -> MinimalForbiddenDenominator[n, k, z]
        |>
    ];

ClearAll[simulateStreakTrial];
simulateStreakTrial[n_Integer?Positive, k_Integer?Positive, pred_] /; k >= 2 :=
    Module[{prev, streak = 1, draws = 1, next},
        prev = RandomInteger[{1, n}];
        While[streak < k,
            next = RandomInteger[{1, n}];
            draws++;
            If[pred[prev, next], streak++, streak = 1];
            prev = next;
        ];
        draws
    ];

ClearAll[monteCarloReport];
monteCarloReport[n_, k_, trials_Integer?Positive, pred_, analyticVal_, returnSamples_] :=
    Module[{samples, analytic = N[analyticVal, 20], assoc},
        samples = Table[simulateStreakTrial[n, k, pred], {trials}];
        assoc = <|
            "Mean" -> N[Mean[samples], 20],
            "StandardDeviation" -> N[StandardDeviation[samples], 20],
            "SampleCount" -> trials,
            "AnalyticExpectation" -> analytic,
            "Error" -> N[Mean[samples] - analytic, 20],
            "RelativeError" -> N[(Mean[samples] - analytic)/analytic, 20],
            "Samples" -> None
        |>;
        If[TrueQ[returnSamples],
            assoc["Samples"] = samples,
            assoc["Samples"] = None
        ];
        assoc
    ];

Options[MonteCarloStreakWaitingTime] = {"Trials" -> 1000, "ReturnSamples" -> False};
ClearAll[MonteCarloStreakWaitingTime];
MonteCarloStreakWaitingTime[n_Integer?Positive, k_Integer?Positive, opts : OptionsPattern[Options[MonteCarloStreakWaitingTime]]] /; k >= 2 :=
    Module[{trials = OptionValue["Trials"], ret = OptionValue["ReturnSamples"]},
        monteCarloReport[n, k, trials, (#2 > #1) &, ExpectedDrawsToStreak[n, k], ret]
    ];

Options[MonteCarloSoftStreakWaitingTime] = {"Trials" -> 1000, "ReturnSamples" -> False};
ClearAll[MonteCarloSoftStreakWaitingTime];
MonteCarloSoftStreakWaitingTime[n_Integer?Positive, k_Integer?Positive, opts : OptionsPattern[Options[MonteCarloSoftStreakWaitingTime]]] /; k >= 2 :=
    Module[{trials = OptionValue["Trials"], ret = OptionValue["ReturnSamples"]},
        monteCarloReport[n, k, trials, (#2 >= #1) &, SoftStreakExpectedDraws[n, k], ret]
    ];

End[];

EndPackage[];
