# Runtime Adapter Implementation Closure

## Scope

Executed the post-governance implementation sequence for the Accelerate adapter
roadmap:

- committed the gstack-inspired governance baseline
- promoted browser proof capture from planned contract to available runtime helper
- expanded GitHub PR workflow helpers while keeping full adapter truth planned
  until create/rehydrate/land live proof exists
- selected Linear MCP as the preferred Linear adapter path, with writes guarded
  until structured non-LLM write binding exists
- added guarded ship-readiness and land helpers

## Evidence

- baseline commit: `b0c5116 Add gstack-inspired workflow governance`
- browser helper commit: `45c3397 Add browser proof runtime helper`
- GitHub PR helper expansion commit: `8563a5c Implement GitHub PR workflow adapter`
- Linear MCP adapter commit: `4ce84ef Implement Linear MCP workflow adapter`
- safety correction: Linear remains `planned` because shell helpers currently
  route MCP writes through an LLM prompt rather than a structured direct binding
- ship/land commit: `4347d06 Add guarded ship and land helpers`

## Live Proof Already Captured

- GitHub PR read/attach live proof used temporary PR `#1` and comment
  `https://github.com/marcelokarval/accelerate/pull/1#issuecomment-4329141970`
- Linear MCP read/write live proof used temporary issue `P4Y-1270`, assigned to
  `marcelokarval@gmail.com`, under project `Prop4You`, then canceled it after
  comment proof

## Boundaries

- Browser helper is available and locally executable, but real capture depends on
  Node plus Puppeteer/Puppeteer Core availability in the target environment.
- GitHub PR remains `planned` as a full workflow adapter until create,
  rehydration, recovery, and land helpers have live proof.
- GitHub land helper is fail-closed and requires `ACCELERATE_ALLOW_LAND=1` for
  real merge plus a matching ship-readiness artifact for the current repo,
  branch, and PR number.
- Deploy remains outside GitHub PR land unless a separate deploy target adapter
  is added.
- Linear GraphQL helpers remain secondary.
- Linear MCP is authenticated and live-tested, but governed write helpers require
  `ACCELERATE_ALLOW_LLM_MCP_WRITE=1` and the adapter remains `planned` until a
  structured write path is available.
