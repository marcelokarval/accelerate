# Privacy Classification

Accelerate classifies operational artifacts before export, sync, or reporting.

## Classes

| Class | Meaning | Export Default |
| --- | --- | --- |
| public-artifact | Safe project documentation or generated packet. | allowed if allowlisted |
| internal-operational | Local workflow state, timeline, review records. | blocked unless explicit |
| sensitive-local-proof | Browser evidence, screenshots, logs, traces. | blocked unless explicit |
| secret-prohibited | Secrets, tokens, cookies, credentials, private keys. | never |
| user-private-preference | User choices, preferences, taste, behavior. | blocked unless explicit |
| generated-export | Derived export from allowed artifacts. | allowed if source allowed |

Unknown classes fail closed.
