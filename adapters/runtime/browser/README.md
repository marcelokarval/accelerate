# Browser Runtime Helper

The `browser/` runtime surface is the generic helper contract for browser proof
capture, including screenshots, console logs, network logs, and QA proof.

Canonical first-pass interactive browser truth is owned by `chrome-devtools/`.
Use this helper surface for local proof capture utilities such as
`capture-browser-proof.sh` and keep Chrome DevTools routing in the
`chrome-devtools/` adapter.

Any implementation must avoid contaminated shared browser state. If a Chrome
DevTools profile conflict occurs, the adapter should prefer isolated execution or
a dedicated temporary `userDataDir`; intentional reuse of an existing session
must be packeted, and blocked browser proof must block browser-required closure.

This directory defines contract expectations. It does not claim a live browser
daemon implementation.
