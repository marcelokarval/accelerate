---
name: dogfood
description: Codex-native exploratory QA skill for web applications — navigate real flows, capture evidence, classify issues, and generate structured bug reports.
version: 1.0.0
metadata:
  category: review
  origin: standalone-adapted-from-global
  tags: [qa, testing, browser, web, dogfood]
  related_skills: [product-runtime-review, verification-before-completion]
---

# Dogfood

## Overview

This skill guides you through systematic exploratory QA testing of web applications using the browser toolset. You will navigate the application, interact with elements, capture evidence of issues, and produce a structured bug report.

## Prerequisites

- A browser-capable toolset or MCP server must be available (for example Chrome DevTools, Playwright MCP, or an equivalent browser automation surface)
- A target URL and testing scope from the user

## Inputs

The user provides:
1. **Target URL** — the entry point for testing
2. **Scope** — what areas/features to focus on (or "full site" for comprehensive testing)
3. **Output directory** (optional) — where to save screenshots and the report (default: `./dogfood-output`)

## Workflow

Follow this 5-phase systematic workflow:

### Phase 1: Plan

1. Create the output directory structure:
   ```
   {output_dir}/
   ├── screenshots/       # Evidence screenshots
   └── report.md          # Final report (generated in Phase 5)
   ```
2. Identify the testing scope based on user input.
3. Build a rough sitemap by planning which pages and features to test:
   - Landing/home page
   - Navigation links (header, footer, sidebar)
   - Key user flows (sign up, login, search, checkout, etc.)
   - Forms and interactive elements
   - Edge cases (empty states, error pages, 404s)

### Phase 2: Explore

For each page or feature in your plan:

1. **Navigate** to the page using the active browser surface.
2. **Capture page structure** using whichever DOM/snapshot capability the tool exposes.
3. **Check runtime console output** for JavaScript errors after each navigation and significant interaction.
4. **Capture visual evidence** with screenshots or annotated screenshots when the active browser tooling supports them.
5. **Test interactive elements** systematically:
   - click buttons and links
   - fill forms
   - test keyboard navigation
   - scroll long pages
   - test invalid and empty submissions
6. **After each interaction**, check for:
   - console/runtime errors
   - visual changes
   - expected vs actual behavior

If the active browser tooling uses different command names than the examples in
older workflows, adapt the procedure to the live tool surface rather than
forcing stale command names.

### Phase 3: Collect Evidence

For every issue found:

1. **Take a screenshot** showing the issue:
   ```
   browser_vision(question="Capture and describe the issue visible on this page", annotate=false)
   ```
   Save the `screenshot_path` from the response — you will reference it in the report.

2. **Record the details**:
   - URL where the issue occurs
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Console errors (if any)
   - Screenshot path

3. **Classify the issue** using the issue taxonomy (see `references/issue-taxonomy.md`):
   - Severity: Critical / High / Medium / Low
   - Category: Functional / Visual / Accessibility / Console / UX / Content

### Phase 4: Categorize

1. Review all collected issues.
2. De-duplicate — merge issues that are the same bug manifesting in different places.
3. Assign final severity and category to each issue.
4. Sort by severity (Critical first, then High, Medium, Low).
5. Count issues by severity and category for the executive summary.

### Phase 5: Report

Generate the final report using the template at `templates/dogfood-report-template.md`.

The report must include:
1. **Executive summary** with total issue count, breakdown by severity, and testing scope
2. **Per-issue sections** with:
   - Issue number and title
   - Severity and category badges
   - URL where observed
   - Description of the issue
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshot references (use `MEDIA:<screenshot_path>` for inline images)
   - Console errors if relevant
3. **Summary table** of all issues
4. **Testing notes** — what was tested, what was not, any blockers

Save the report to `{output_dir}/report.md`.

## Browser Capability Reference

Map the workflow onto the browser surface you actually have available.
Typical capability buckets are:

| Capability | Purpose |
|------|---------|
| navigation | Go to a URL or move through the app |
| snapshot / DOM inspection | Understand page structure and available interactive elements |
| click / type / keyboard input | Exercise the flow |
| screenshot / visual capture | Preserve issue evidence |
| console / logs | Capture runtime errors and warnings |
| tab / history / scroll controls | Explore route families and below-the-fold surfaces |

## Relationship To Other Skills

- `product-runtime-review` governs whether the user-facing runtime behavior is actually good product
- `verification-before-completion` decides whether the collected browser evidence is strong enough to support closure
- `accelerate/references/qa-proof-stack.md` treats `dogfood` as a valid exploratory browser-QA companion when issue capture is the main need

## Tips

- **Always check the runtime console/log surface after navigating and after significant interactions.** Silent JS errors are among the most valuable findings.
- **Use annotated screenshots or DOM labels when available** to reason about interactive element positions and route-family breadth.
- **Test with both valid and invalid inputs** — form validation bugs are common.
- **Scroll through long pages** — content below the fold may have rendering issues.
- **Test navigation flows** — click through multi-step processes end-to-end.
- **Check responsive behavior** by noting any layout issues visible in screenshots.
- **Don't forget edge cases**: empty states, very long text, special characters, rapid clicking.
- When the platform supports inline screenshot references, include them in the report so the evidence stays attached to the finding.
