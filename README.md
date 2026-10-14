# V5 mixture and curriculum plan

**Local draft, not committed.** Read the [full specification](PLAN.md), [proxy results](proxy-summary.csv), and [reproducible experiment](proxy.ps1). The lesson and session transcript are saved alongside them.

## Decision to test

At equal processed-token budget, staged training with protected native Indic, reasoning and late agentic quotas should improve Indic fluency and multi-step recovery while retaining coding and general knowledge. The numbers below are hypotheses; the local experiment verifies sampler mechanics, not model capability.

| Capability | Main run | Final cooldown | Main-run datasets |
|---|---:|---:|---|
| General web | 40% | 10% | DCLM-Baseline, FineWeb-Edu |
| Code | 25% | 25% | The Stack v2, CommitPack |
| STEM | 10% | 8% | peS2o, proof-pile-2 |
| Indic | 15% | 25% | Sangraha verified/unverified, IndicCorpV2, translated Sangraha, Samanantar, BPCC |
| Reasoning foundations | 4% | 10% | Audited proofs/math exposition; effort traces saved for post-training |
| Long context | 5% | 12% | Coherent repo-packed code and long documents |
| Agentic preparation | 1% | 10% | Verified SWE-smith/OpenHands/SWE-Gym rollouts; function-call sets as prerequisites |
| **Total** | **100%** | **100%** | |

Reference accounting: 990B main tokens plus a **10B disjoint cooldown reserve**; scale only after the actual cohort budget and cleaned supply are fixed. A separate 2B post-training budget allocates 50/30/10/10% to reasoning/agentic/Indic/code. Masked context counts toward processed tokens; supervised tokens are reported separately.

Indic main split: **50% verified native, 25% unverified native, 20% translated, 5% generated synthetic**. Cooldown split: 70/10/10/10%. Sangraha's named “synthetic” component is translated/romanised material, so it belongs in the translated category here. Language quotas cover 22 scheduled languages with a minimum 2% each inside Indic and the remainder weighted by square-root native supply. Missing stock blocks that language allocation rather than quietly increasing Hindi.

## What changes from V4

- **Selector starvation:** Indic ≥10% of each optimizer-step token budget, including verified native ≥6%; reasoning foundations ≥2%. Agentic ≥1% after late activation. Rank within residual lane quotas, never globally renormalise scarce lanes away.
- **Little agentic data and no live harness:** collect executable multi-step trajectories, including failures/recovery, validated by actual tool state and tests. Tool observations receive zero loss. Synthetic function calls alone do not establish agent competence.
- **Poor cleaning/accounting:** retokenise after script-aware normalization and global dedup; canonical conversation tokens; runtime language validation; source/license/hash manifests; train/eval cluster isolation. Long packed code is removed from the ordinary code ledger to avoid double counting.
- **Unstaged selector difficulty:** selector-development tasks progress with curriculum and inspect recovery/final windows, rather than only the first 512 tokens. Final test sets remain hidden.
- **Abrupt mixture seams:** blended transitions, trainable embeddings, per-lane losses and pre-clip gradients, rollback on nonfinite values or sustained >5x gradient norms.

Main curriculum spends 25/50/25% on foundation/capability/context preparation, preserving the aggregate table exactly. Sequence length rises 4K→8K→16K→32K. The best reserve is inaccessible until cooldown. Difficulty progresses from B0 native simple sentences through B1 arithmetic, B2 algebra, B3 BFS, B4 Bayesian inference, to B5 cross-file race repair, with simpler replay. Later effort SFT uses low/medium/high/ultra maximum trace budgets of 128/512/2048/8192 tokens; easy tasks are never padded merely to fill a band.

## Supply is the decisive constraint

Inventory sizes are course estimates, not team-owned clean stock. At optimistic supply, verified Indic requires repetition within a 2x cap. Generated Indic requires at least **3.9625B new validated unique tokens**. The main plus cooldown agentic proposal requires at least **3.115B new unique trajectory tokens**, even allowing 4x main repetition of the small existing trajectory stock. Reasoning foundations cannot be filled by counting inaccessible V4 AON tokens or relabelling long chat traces. These gaps are explicit prerequisites; reduce shares and rerun experiments if acquisition fails. Full per-tier arithmetic and repeat caps are in [PLAN.md](PLAN.md).

## Evidence and acceptance

Executed locally: **10 seeds × 20 batches**, 2,500 simulated candidate blocks and 1,000 selected per batch. Under the deliberately biased fixture, global selection retained 0% Indic/reasoning/agentic and violated each protected floor in all 200 batches. Quota-protected selection retained exactly 15/4/1% with zero violations. Role masks and reserve checks passed. [Measured results and limitations](EXPERIMENT_RESULTS.md) explain why this supports the mechanism but does not validate these particular shares. This is a structural proxy using synthetic scores, **not OPUS or a 1B/3B model-training run**.

Required model screen: **1B parameters, 20B training tokens per arm**, three paired seeds for flat/unprotected, staged/unprotected, and staged/protected+reserve. Confirm baseline versus winner at **3B parameters, 60B tokens per arm**, three seeds. Use identical tokenizer, architecture family, optimizer, post-training recipe, decoding/tool budgets and frozen evaluation versions. Report compute and wall time as well as tokens.

Pre-register: MILU macro accuracy +2 points, agentic success +3 points and recovery +5 points; code and MMLU lose no more than 1 point. Require paired confidence intervals, per-language scores, effort compliance ≥95%, and 32K dependency accuracy ≥90% of 8K. Failed or inconclusive gates trigger a targeted matched-budget ablation, not a full-scale launch.

**Outstanding:** actual 1B/3B training, cleaned manifests and the team's cumulative data gate. Session 4 asks for a 10–100M dataset, but does not establish a numeric cumulative Session 5 gate. No model-training executable/GPU command was found on PATH, and no cleaned corpus or checkpoint was supplied. This package is a testable plan with an executed structural test; it is not yet evidence of assignment completion at model scale.

Sources, uncertainty notes, detailed thresholds and run protocol are in [PLAN.md](PLAN.md). No Git operation or external submission was performed.
