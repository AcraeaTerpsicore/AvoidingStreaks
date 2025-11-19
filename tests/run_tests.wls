(* Load implementation *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "src", "Streaks.wl"}]];

ClearAll[gfValue, gfAltValue];

gfValue[n_, k_, z_] := N[StreakGeneratingFunction[n, k][z], 40];
gfAltValue[n_, k_, z_] := N[StreakGeneratingFunctionAlt[n, k][z], 40];

softGFValue[n_, k_, z_] := N[SoftStreakGeneratingFunction[n, k][z], 40];
softGFAltValue[n_, k_, z_] := N[SoftStreakGeneratingFunctionAlt[n, k][z], 40];

tests = Flatten@{
    VerificationTest[Psi[5, 0], 1, TestID -> "psi-multiple"],
    VerificationTest[Psi[5, 1], -1, TestID -> "psi-offset"],
    VerificationTest[Psi[5, 3], 0, TestID -> "psi-zero"],
    VerificationTest[Psi[2, -1], -1, TestID -> "psi-negative"],

    Table[
        With[{n = 3, k = 3},
            VerificationTest[
                StreakCount[n, k, s],
                CountWordsWithoutStreak[n, k, s],
                TestID -> "streak-count-" <> ToString[s]
            ]
        ],
        {s, 0, 4}
    ],

    VerificationTest[
        Chop[gfValue[4, 3, 0.05] - gfAltValue[4, 3, 0.05], 10^-25],
        0,
        TestID -> "gf-alt-match"
    ],

    VerificationTest[
        Simplify[ExpectedDrawsToStreak[4, 3] - StreakGeneratingFunction[4, 3][1/4]],
        0,
        TestID -> "expected-gf"
    ],

    VerificationTest[
        GeneralizedBinomialB[4, 3, 5],
        Coefficient[Expand[(1 + x + x^2)^4], x^5],
        TestID -> "generalized-binomial"
    ],

    VerificationTest[
        Simplify[
            MinimalForbiddenGeneratingFunction[5, 3][z] -
            Sum[z^i, {i, 0, 2}]/(1 - (5 - 1)*Sum[z^i, {i, 1, 3}])
        ],
        0,
        TestID -> "minimal-gf"
    ],

    VerificationTest[
        MinimalForbiddenDenominator[6, 4, 1/6],
        (1/6)^4,
        TestID -> "minimal-denominator-bound"
    ],

    VerificationTest[
        MinimalForbiddenRadiusLowerBound[6, 4],
        <|"CandidateBound" -> 1/6, "DenominatorAtBound" -> (1/6)^4|>,
        TestID -> "minimal-radius"
    ],

    VerificationTest[
        BlockRandom[
            SeedRandom[2024];
            MonteCarloStreakWaitingTime[3, 3, "Trials" -> 5, "ReturnSamples" -> True]["Samples"]
        ],
        {25, 26, 27, 3, 26},
        TestID -> "mc-strict-samples"
    ],

    VerificationTest[
        BlockRandom[
            SeedRandom[2024];
            MonteCarloStreakWaitingTime[3, 3, "Trials" -> 5]
        ]["Samples"],
        None,
        TestID -> "mc-strict-nosamples"
    ],

    VerificationTest[
        BlockRandom[
            SeedRandom[3031];
            MonteCarloSoftStreakWaitingTime[3, 3, "Trials" -> 5, "ReturnSamples" -> True]["Samples"]
        ],
        {3, 3, 6, 4, 5},
        TestID -> "mc-soft-samples"
    ],

    Table[
        With[{n = 3, k = 3},
            VerificationTest[
                SoftStreakGeneratingFunction[n, k][1/10] // N,
                SoftStreakGeneratingFunctionAlt[n, k][1/10] // N,
                SameTest -> (Chop[#1 - #2, 10^-20] == 0 &),
                TestID -> "soft-gf-alt"
            ]
        ],
        {1}
    ],

    Table[
        With[{n = 3, k = 3},
            VerificationTest[
                SeriesCoefficient[SoftStreakGeneratingFunction[n, k][z], {z, 0, s}],
                CountWordsWithoutSoftStreak[n, k, s],
                TestID -> "soft-count-" <> ToString[s]
            ]
        ],
        {s, 0, 4}
    ],

    VerificationTest[
        Simplify[
            SoftStreakExpectedDraws[3, 3] -
            SoftStreakGeneratingFunction[3, 3][1/3]
        ],
        0,
        TestID -> "soft-expected-gf"
    ],

    VerificationTest[
        True,
        True,
        SameTest -> (Abs[N[ContinuousStreakExpectation[3], 30] - N[ExpectedDrawsToStreak[200, 3], 30]] < 10^-8 &),
        TestID -> "continuous-limit"
    ]
};

report = TestReport[tests];

Print[report // ToString];

If[report["TestsFailed"] > 0,
    Exit[1],
    Exit[0]
];
