# Runtime Adapter Registry Contract

Runtime adapters declare capabilities without making core depend on host paths or
tools.

Required fields: `name`, `type`, `status`, `authority_boundary`, `allowed_tools`,
`suppressed_capabilities`, `validation_command`, `proof_artifacts`, and
`privacy_notes`.

Allowed status values: `planned`, `available`, `experimental`, `disabled`.
