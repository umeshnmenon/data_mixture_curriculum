# Executed structural proxy: results

Run completed successfully on 2026-10-13 using Windows PowerShell and the saved `proxy.ps1`. No model weights were trained. No remote service or paid compute was used.

Ten seeds, twenty batches per seed, 2,500 equal-length candidate blocks per batch, 1,000 selected per batch: **500,000 candidate blocks evaluated per policy, 200,000 retained per policy**. The same candidate batches feed both policies. Fixture scores for web/code/STEM/long are uniform [0.8,1.8); Indic/reasoning/agentic scores are uniform [0,1). This deliberately severe bias is a stress test, not an estimated real-world score distribution.

| Lane | Global selection mean % | Quota-protected mean % | Global floor violations / 200 | Protected violations / 200 |
|---|---:|---:|---:|---:|
| Web | 50.048 | 40 | 0 | 0 |
| Code | 31.249 | 25 | 0 | 0 |
| STEM | 12.4825 | 10 | 0 | 0 |
| Indic | 0 | 15 | 200 | 0 |
| Reasoning | 0 | 4 | 200 | 0 |
| Long context | 6.2205 | 5 | 0 | 0 |
| Agentic | 0 | 1 | 200 | 0 |

The quota policy retained exactly 1,000 distinct blocks per batch and reproduced the declared reference shares. Because quota counts are deterministic, there is no statistical uncertainty in their percentages. Seed variation affects which scored blocks are selected. Results support quota enforcement as a protection mechanism; they **do not show that the chosen floor values are optimal**. This tests aggregate lanes at the reference mixture, not real-language subquotas or variable-length packed sequences.

Other checks:

- Role-mask fixture: 425 total fixture tokens, 105 assistant tokens supervised; 300 tool-observation tokens and 20 user tokens masked. No tool tokens supervised.
- Reserve fixture: zero main/reserve ID overlap. Deliberately inserting one overlapping ID was detected. This is an identity-level software check, not production near-dedup validation.
- Transition calculation: hard shift L1 distance 34 percentage points; dividing the same change into 100 linear steps gives 0.34 points per step. This is arithmetic about distribution changes, **not a measured gradient reduction**.

Artifacts: `proxy-batches.csv` (2,800 lane rows), `proxy-summary.csv` (14 aggregates), `proxy-checks.json`, `proxy.ps1`. Rerun with `powershell -NoProfile -File .\proxy.ps1` from this folder. The PowerShell reference implementation is intentionally simple and may take several minutes.

Conclusion for the plan: preserve exact lane quotas outside global selection; retain mask and reserve checks. Do not approve the mixture for full-scale training on this result. Run the pre-registered 1B and 3B matched-budget model experiments in `PLAN.md`, with actual cleaned manifests and execution harnesses.
