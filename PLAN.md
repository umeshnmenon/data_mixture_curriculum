# V5 mixture and curriculum: falsifiable draft

**Status: local review draft; no Git commit or submission.** A local structural proxy was executed (see `proxy-summary.csv`, `proxy-checks.json`, and `proxy.ps1`). It tests allocation plumbing, not model learning. **1B and 3B parameter training has not been run.** The cleaned-data gate is also unverified; this document must not be represented as a completed, empirically validated assignment.

## 1. Hypothesis and fixed accounting

At equal processed-token budget, a staged, quota-constrained mixture with native Indic protection will improve Indic understanding and agent recovery without materially reducing code or general knowledge. The proposed shares are experimental starting points, not optimal numbers established by the session.

Use a **1T processed-token reference budget for base training plus cooldown**, scalable after the cohort declares its actual budget. The transcript mentions 2.4–4T; 1T here is an accounting unit, not a claim about the cohort's final run. Count context tokens even when masked. Report supervised tokens separately. Online rejected candidates consume selection compute but do not count as processed training tokens. Post-training gets its own budget below.

| Lane | Main-run reference share | At 990B main tokens | Cooldown share | At 10B cooldown tokens | Purpose and evidence to collect |
|---|---:|---:|---:|---:|---|
| General web | 40% | 396B | 10% | 1B | Preserve breadth/common sense; MMLU accuracy and general held-out loss |
| Code | 25% | 247.5B | 25% | 2.5B | Strong coding target; LiveCodeBench pass@1, Aider edit success |
| STEM | 10% | 99B | 8% | 0.8B | Scientific foundations; GPQA Diamond accuracy |
| Indic | 15% | 148.5B | 25% | 2.5B | Native fluency is the differentiator; MILU macro accuracy, IndicGenBench task metrics |
| Reasoning foundations | 4% | 39.6B | 10% | 1B | Verified mathematical/proof documents in base training; AIME exact answer |
| Long-context | 5% | 49.5B | 12% | 1.2B | Cross-file/document dependencies; retrieval and task success at each trained length |
| Agentic preparation | 1% | 9.9B | 10% | 1B | Late, assistant-masked trajectories; BFCL, terminal success, recovery success |
| **Total** | **100%** | **990B** | **100%** | **10B** | **1T processed tokens** |

Why these numbers: web stays the largest main lane because breadth is valuable and abundant. Code gets the next largest allocation because coding is a primary target. Indic rises above V4's 8% protection but stays below an unaffordable native-only 25% main mixture. STEM plus reasoning use 14% initially rather than V4's late ~39% science/math; the freed budget purchases Indic and long-context exposure. Agentic starts at only 1% because its supply is orders of magnitude smaller. The 1% cooldown follows the transcript's last-1% discussion; compare 1% versus 2% in a later ablation. Every trade-off is subject to the gates in section 7.

The long-context lane is an exclusive accounting assignment: a repo packed into it is removed from the code supply ledger. Language, domain, difficulty, source, and length remain secondary tags. Never count one token twice.

## 2. Indic tiers and languages

| Exclusive provenance category | Share inside Indic main | Main exposure | Share inside Indic cooldown | Cooldown exposure |
|---|---:|---:|---:|---:|
| Verified native | 50% | 74.25B | 70% | 1.75B |
| Unverified native, quality filtered | 25% | 37.125B | 10% | 0.25B |
| Translated | 20% | 29.7B | 10% | 0.25B |
| Generated synthetic, not translation | 5% | 7.425B | 10% | 0.25B |

Sangraha's component named **Synthetic is translated/romanised English**, according to its dataset card. Put it in the translated ledger here, not the generated-native ledger. Romanised variants must be linked to the source and clustered before splits. A publisher's verified-source label does not establish that every OCR/transcribed sentence is correct or natively authored. Audit samples and retain modality tags.

Start with the 22 scheduled languages supported by the source inventory: assign 2% of the Indic lane to each (44% total); distribute the remaining 56% in proportion to the square root of cleaned, deduplicated native-token supply. This reduces Hindi dominance without pretending equal supply. Publish the resulting 22-language table only after manifests exist. If a language cannot sustain its allocation under the repeat cap, report a deficit and block the run; do not silently redirect its quota to Hindi. Protect native-script material; romanised content is capped at 10% of Indic exposure. Track per-language metrics and scripts, not just aggregate Hindi-heavy scores. Sanskrit and Urdu are included but supply constrained.

## 3. Inventory, repetition, and unmet supply

These are **session-widget estimates**, not downloaded, cleaned, disjoint stock. All sizes must be retokenised with the frozen V5 tokenizer and reduced for source overlap, contamination, quality rejection, and reserve withholding. No cleaned dataset was present in this workspace. No V4-private corpus is assumed accessible.

| Lane | Named session inventory | Headline tokens | Supply decision |
|---|---|---:|---|
| Web | DCLM-Baseline, FineWeb-Edu; D1/D2 V4 only if released | 2.6T, 1.3T; 164B/627B private lineage | Public headline supply exceeds 397B exposure; require disjoint retained count |
| Code | The Stack v2; CommitPack/FT; D3 V4 if released | 900B; 4B; 199B | 250B exposure likely feasible before losses; subtract repo-packed overlap |
| STEM | peS2o, proof-pile-2; D4 if released | 42B, 55B; 49B | 99.8B exceeds public 97B before cleaning; acquire at least 2.8B unique or documented repeats |
| Reasoning | AON V4; OpenMathReasoning, OpenThoughts2, NuminaMath, OpenR1-Math | 78B private; 2B/3B/0.5B/1.6B estimates | 40.6B foundation demand cannot be filled by blindly treating traces as base documents; foundation stock must be counted separately; trace sets reserved for post-training |
| Long | Repo-packed code 32K+, book/long documents | 60B + 40B | 50.7B exposure; exclusive IDs, preserve coherent dependencies and verify rights |
| Indic native verified | Sangraha verified | 64B | Main 74.25B + reserve 1.75B: at least 12B repeats/acquisition at headline supply |
| Indic native unverified | Sangraha unverified, IndicCorpV2 | 24B + 20.9B | 37.375B; overlaps likely, no additive-stock assumption |
| Indic translated | Sangraha synthetic; Samanantar; BPCC | 162B + 2B + 3B | 29.95B demand; parallel corpora must be checked for overlap and tokenizer counts |
| Indic generated | Locally generated, human/checker validated examples | **0 audited tokens available** | 7.675B exposure: generation is a prerequisite, not existing supply |
| Agentic | ToolBench 80M, Glaive 50M, ToolACE 60M, xLAM/APIGen 25M, Nexus 30M, Hermes 22M; SWE-smith 120M, OpenHands 90M, SWE-Gym 150M | 627M total; 360M trajectory subgroup | 10.9B demand; function calls are not long trajectories; task instances are not automatically rollouts |

Repetition limits are hypotheses: native verified maximum 2 total exposures per record, unverified/translated maximum 1, generated Indic maximum 2, agentic maximum 4, reasoning maximum 2, broad web/code/STEM maximum 2. Limits are across main plus cooldown and checked by clustered source identity. Cooldown records must have zero main-run exposure.

For each tier, compute `new_unique_needed = max(0, main_exposure / main_repeat_cap - (clean_unique - cooldown_unique_reserve))`; count reserve separately, then deduplicate across tiers. At optimistic 64B verified native and a 1.75B reserve, 74.25B main exposure needs 1.19 passes over 62.25B. This passes the 2x cap before cleaning; >40% cleaning loss would require new data. The generated Indic lane requires at least 3.7125B main unique + 0.25B reserve = **3.9625B newly validated unique tokens**.

For agentic, reserve 100M of the optimistic 360M trajectory stock for cooldown, leaving 260M. Four passes provide 1.04B main exposure, leaving **8.86B main exposure unfilled**. At 4x maximum, acquire at least 2.215B new main unique + 0.9B new cooldown unique = **3.115B new trajectory tokens**, optimistically ~156K accepted 20K-token trajectories. At 50% acceptance this means ~312K attempts. Validate repository tests/tool state, preserve failed-call recovery, and reject fabricated observations. This arithmetic does not assume those trajectories have been generated. If this is infeasible, reduce agentic budget explicitly and rerun the matched-budget proxy; full-scale approval remains blocked.

Correct interpretation of uncertainty: the inventory's 85.1B reasoning total includes an inaccessible 78B V4 corpus. SWE-smith's paper describes 50K task instances, different from the widget's 26K sample estimate; neither guarantees the widget's 120M rollout tokens. OpenMathReasoning's card supports 3.2M long solutions, not the widget's token estimate. Licenses in the widget are screening metadata; per-source eligibility and opt-outs must be checked.

## 4. Curriculum and stage-appropriate objectives

To preserve the exact 990B main totals while deferring hard material, allocate 25% of main tokens to Foundation, 50% to Capability, and 25% to Context/agent preparation:

| Stage | Share of main budget | Web | Code | STEM | Indic | Reasoning foundations | Long | Agentic | Context |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Foundation | 25% | 58% | 18% | 10% | 12% | 2% | 0% | 0% | 4K |
| Capability | 50% | 39% | 27% | 10% | 15% | 4% | 5% | 0% | 4K then 8K |
| Context / preparation | 25% | 24% | 28% | 10% | 18% | 6% | 10% | 4% | 16K then 32K |
| Cooldown, separate | 10B | 10% | 25% | 8% | 25% | 10% | 12% | 10% | mix of trained lengths |

The weighted main shares exactly equal section 1. Stage transitions blend over centred **3B-token bands**, using symmetric linear interpolation; this preserves integrated token totals around boundaries. Apply a separate 0.3B-token ramp at context-length changes and the cooldown seam; the executable production ledger must integrate that ramp and compensate within adjacent stage quotas so final exposures remain exact. Never add warmup tokens outside the budget. Use one sequence length per microbatch, token-based global batch sizing and gradient accumulation, and block-diagonal attention when packing unrelated documents. Do not truncate a 32K dependency into 4K fragments and claim long-context training. No 1M-context claim is made.

Base documents: next-token loss on document tokens. The reasoning foundation lane contains proofs/math exposition, not effort-labelled long chat traces. Late agent trajectories and cooldown agent examples use **assistant-only loss**, with system/user/repository/tool observations masked. This is an explicitly separate masked training objective inside the late phase, rather than pretending all base tokens have the same loss. Never supervise a tool log. Report effective supervised-token fraction and loss normalisation per objective.

After cooldown, reserve an additional **2B processed post-training tokens**: reasoning 50%, agentic 30%, Indic assistant examples 10%, code instruction/edit 10%. Response-only SFT precedes reasoning RL with answer/test verifiers; preference alignment is separate and its budget remains to be agreed. This later budget is not inside 1T. Effort-labelled traces are taught here, not relied on to emerge from base training.

## 5. Floors, reserve, and stability

Per optimizer-step token quota: Indic at least **10%**, including at least **6% verified native** of the whole batch; reasoning foundations at least **2%**. Agentic floor is **0% before activation**, then **1%** in the late phase and cooldown. No long reasoning traces are forced into foundation training. In reasoning SFT, protect **10% long/ultra traces** and 15% Indic examples. These are stage-specific floors, not a misleading unconditional promise to use agent data at token zero.

The selector ranks **within each lane's residual quota**, after protected tokens are allocated; it cannot renormalise scarce lanes away. Use token counts, not sample counts. If eligible supply is missing, fail closed with a shortage record. Initially retain 40% of candidates in residual quotas and compare 60%/100%; treat the session's ~6x effective-token benefit as a V4 report, not a V5 forecast. Use disjoint selector-development tasks; keep final benchmarks invisible to the selector. Inspect several trajectory windows including recovery/final actions, because the transcript warns that first-512-token scoring misses late value. Measure selector wall-clock overhead and actual marginal validation gains.

Reserve 10B disjoint Tier-A/highest-audited-quality cooldown tokens: web 1B, code 2.5B, STEM 0.8B, native/other Indic 2.5B as above, reasoning foundations 1B, coherent long-context 1.2B, agentic 1B. This is a **procurement target**, not present stock. Route reserves to isolated manifests invisible to ordinary sampler and selector; decontaminate by document/repository/source cluster before partitioning. Datasets used for selector development, training, cooldown, and final evaluation are mutually disjoint at cluster level.

Train embeddings during language rebalancing. Record per-language exposure, pre-clip gradient norm, embedding gradient norm, loss by lane, finite values, clipping rate, and throughput. Proposed stop: any nonfinite value immediately; or pre-clip norm >5x trailing median for 3 steps; or lane validation loss >10% above baseline for two checks. Restore pre-seam model/optimizer/dataloader state, halve transition learning rate, double ramp width within budget, and replay the seam. Clip gradients, but never treat clipping as proof of stability. The lesson says Hindi share increased; the spike widget says it was cut. Both support auditing any abrupt shift with frozen embeddings, not assuming a particular direction.

## 6. Difficulty and effort bands

| Band | Concrete example | Scheduling |
|---|---|---|
| B0 nursery | Hindi: “यह लाल गेंद है।” Match object and colour | Foundation dominant |
| B1 grade school | 3 packets of 4 pencils: compute 12 | Foundation, then replay |
| B2 high school | Solve x²−5x+6=0 and verify 2,3 | Foundation/capability overlap |
| B3 undergraduate | Implement BFS shortest paths and test disconnected graph | Capability dominant |
| B4 graduate | Derive a Bayesian posterior and check normalisation | Late capability/context |
| B5 research | Repair cross-file race condition; reproduce failure and verify patch | Late context and cooldown |

Foundation B0–B5 proportions: 15/30/30/20/5/0%; Capability: 5/10/25/35/20/5%; Context: 0/5/15/30/30/20%; Cooldown: 0/5/10/25/35/25%. Audit difficulty with sampled human labels; education labels are approximate. Gradually blend bands and retain simpler replay to avoid forgetting.

Effort SFT trace-token bands (assistant reasoning only, answer excluded): low 0–128; medium 129–512; high 513–2048; ultra 2049–8192. Trace-example proportions 40/30/20/10%, with math/code/general problem-solving each represented. Report token proportions too: equal sample proportions do not imply equal compute.

Examples: low “17+25=42”; medium count integers 1..1000 divisible by 3 or 5 using inclusion–exclusion, answer 467; high design/test dynamic programming for interval scheduling with edge cases; ultra localise a nondeterministic cross-file bug, test competing causes, and verify the repair. Pair a subset of identical tasks across effort requests; the divisibility task should give 467 at every setting, without padding an easy answer to thousands of tokens. Labels specify maximum permitted effort, not a minimum length. Score correctness, budget compliance, and cost jointly; raw trace length is not evidence of reasoning quality.

## 7. Model proxy runs required before trusting the recipe

**1B/3B refer to parameters, not token counts.** Use same tokenizer, architecture family, initialisation/starting checkpoint, optimizer, data versions and evaluation harness across arms. A 1B screen uses 20B processed tokens per arm; 3B confirmation uses 60B per arm. Scale token-stage fractions and transition widths proportionally (3B per 1T becomes 60M at 20B); record actual FLOPs and wall time because long contexts and selection change cost. Training-compute estimates `6*N*T` are 1.2e20 FLOPs per 1B arm and 1.08e21 per 3B arm, before selection/attention/harness overhead. Do not launch paid compute without a defined allocation.

1B screen, 3 paired seeds each: A flat mixture without protection; B staged mixture without protection; C staged + lane quotas/floors + disjoint cooldown reserve (proposed). Each receives identical total processed tokens. After identifying the winner, run targeted same-budget ablations for Indic 10/15/20%, cooldown 1/2%, native-tier mix, agentic activation, selector retention, and short-window versus multi-window scoring. Avoid changing all knobs in one comparison. 3B: confirm A versus selected recipe with 3 paired seeds, fixed choices made from 1B development results.

For each arm apply identical 2%-of-base-token-budget post-training recipe (400M at 1B, 1.2B at 3B), preserving the 50/30/10/10 split; separately report base and assistant checkpoints. Train on available eligible stock only; sample and holdout from disjoint language/source/repository clusters. Pin benchmark revisions and decoding/tool/time budgets, score blind, retain per-task outputs and failures. Development subsets for screening; full pinned suites for confirmation.

Pre-register acceptance against A at equal budget:

- MILU macro accuracy improves ≥2 percentage points, with paired 95% bootstrap interval lower bound >0; no language with adequate sample size drops >2 points. IndicGenBench native summarisation/QA must improve or remain within a predeclared 1-point margin in its own metric.
- Code pass@1 and general MMLU accuracy each remain within 1 absolute point (noninferiority lower bound >−1). Agentic terminal/repository success improves ≥3 points; injected-failure recovery success improves ≥5 points under fixed harness.
- Reasoning hard-task accuracy improves ≥2 points; low-effort median reasoning tokens ≤128 with accuracy within 1 point of baseline. ≥95% effort-budget compliance; higher effort must improve hard-task accuracy, not just length.
- At 32K, dependency/retrieval accuracy ≥90% of 8K result; report middle-position failures. No new nonfinite events; transition p99 pre-clip gradient ratio <3x baseline. Selector overhead ≤10% wall time unless paired gains justify more.

These are proposed decision margins, not claimed scores. Compute bootstrap over tasks and report between-seed dispersion separately. If interval width cannot resolve a margin, expand evaluation or declare inconclusive. FrontierMath/HLE are secondary stretch metrics, not cheap proxy gates; tiny AIME sets alone cannot justify the recipe. If Indic improves but code fails the guardrail, shift 2 points from web to code and retest; if generated Indic harms native quality, replace it with acquired native tokens and report the deficit; if floors hold but agent success does not improve, investigate trajectory quality/harness rather than increasing repetition blindly.

## 8. Executed local proxy and assignment gate

Run `powershell -NoProfile -File .\proxy.ps1`. Ten seeds × twenty batches compare unconstrained top-40% selection against lane-constrained protected selection on deliberately English-biased score fixtures. Each batch has 2,500 equal-length candidate blocks and 1,000 retained blocks. CSVs retain every batch/lane outcome. Also test assistant-only masking, reserve isolation with a deliberately overlapping negative control, and hard versus ramped L1 mixture changes. **Scores are synthetic; this does not implement OPUS or predict benchmark scores/gradient norms.** Exact quota success is a software invariant, not evidence that 15% Indic is optimal.

See `proxy-summary.csv` for observed starvation and floor violations, and `proxy-checks.json` for masking/reserve/transition checks. The experiment tests whether the proposed execution rules avert a known failure mechanism. It cannot establish capability trade-offs, optimal floors, or 1B→full-scale transfer. The requested real parameter-scale proxy remains outstanding.

Cleaning priority: verified native languages with weak stock → executable multi-step/recovery trajectories → long-context coherent sources → separate reasoning foundations/effort traces. Every accepted shard needs source/version/rights evidence, sample count, post-tokenizer tokens, supervised-token count, language/script, provenance category, dedup cluster, contamination checks, difficulty/length, quality score, split, reserve flag, and repeat ledger. Publish raw→clean→unique→reserved→available counts. Do not conflate 40M collected tokens with 40M clean unique tokens.

The assignment says review begins only after the team's cumulative data-gating threshold. Session 4 was checked: its assignment specifies a 10–100M dataset but does not specify this cumulative threshold. Team records must establish it. Current gate status: **unknown, not met by evidence in this workspace**. This draft is ready for review locally, but final submission needs cleaned manifests, real 1B/3B run results, and the eventual GitHub README link. No commit was made.

Additional V4 lessons from the transcript: no live terminal/tool execution harness (around 01:05), training on incorrectly formatted/fully supervised task material (around 01:00), and an unstaged selector-proxy difficulty mix (around 01:50). Require executable rollouts with actual tool feedback, role-correct masks, and stage-specific selector-development tasks. Use the current model checkpoint for selection updates rather than an unrelated distilled model; refresh at a predeclared interval (initial proposal every 100 optimizer steps, tune overhead in the 1B screen).

## Sources and evidence boundaries

- [Session 5 lesson](https://axiom.theschoolofai.in/courses/cmq97i5kn032208o8xu5dab4q/sessions/cmryiscq4002009rhmu56icmp/lesson?zen=1), all twelve sections; local `session5-lesson.txt`.
- [Session transcript](https://docs.google.com/document/d/1VATcZvXczsYwKMDEWoyanB7nfzjrFkXHb2ojf-95kjc/edit), especially 00:10 masking, 01:15–01:20 stages, 01:35–01:45 selector/short windows, 01:55 transitions, 02:00–02:05 assignment/context; local `session5-transcript.md`. Automatically generated transcript has errors.
- [Inventory widget](https://axiom.theschoolofai.in/widgets/widget_9_dataset_inventory.html) and [benchmark widget](https://axiom.theschoolofai.in/widgets/widget_2_benchmark_explainer.html): course estimates and illustrative tasks, not measured training stock.
- [Sangraha dataset card](https://huggingface.co/datasets/ai4bharat/sangraha): provenance semantics; [AI4Bharat release blog](https://ai4bharat.iitm.ac.in/blog/indicllm-suite/): native/unverified release context.
- [SWE-smith paper](https://arxiv.org/abs/2504.21798): task/trajectory distinction; [OpenMathReasoning card](https://huggingface.co/datasets/nvidia/OpenMathReasoning): long-trace source.

V4's ~150x gradient spike and ~6x effective-token claim are course-reported observations, not reproduced here. All proposed allocations, safety margins, repeat caps and acceptance thresholds are explicitly hypotheses requiring model experiments.
