# Review-Of-Review Gate

## Purpose

This gate makes `review-of-review` operational.

It exists because a branch can look well reviewed while earlier reviews still
missed real seams, defects, or comparison gaps.

## Rule

The master should not only inspect the code or final artifact.

The master should judge whether prior reviews were serious enough and whether
they actually supported promotion.

## Acceptance Questions

At minimum, ask:

- did the slice leave a real `requested-vs-implemented` comparison?
- did `self-review` capture concrete defects or only summarize activity?
- did `self-forensic review` inspect seams, boundaries, or likely drift?
- was the defect ledger updated honestly?
- were open defects fixed, waived, or explicitly carried forward?
- did the proof correspond to the corrected state instead of an earlier pass?
- did the review claim more certainty than the evidence supports?
- was the reviewer independent from the executor?
- did the reviewer actively try to disprove the executor's done claim?
- did the final orchestrator inspect review quality instead of trusting it?

## Failure Patterns

Treat these as serious review-of-review failures:

- prose recap with no comparative judgment
- defect noticed but not registered
- correction claimed with no fresh proof
- screenshot or proof from pre-fix state
- review says "done" while `requested-vs-implemented` still shows misses
- review ignores a seam that is a likely defect hotspot
- executor reviewed their own work and treated it as acceptance
- reviewer paraphrased executor claims without adversarial checks
- orchestrator accepted a reviewer report without review-of-review

## Output

The gate should leave:

- whether prior reviews were sufficient
- what they missed, if anything
- whether the branch can still promote
- whether the correction is local-to-branch or workflow-level

## Relationship To Closure

`review-of-review` happens before final forensic closure.

Its purpose is to keep closure from inheriting weak intermediate judgment.
