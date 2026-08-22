# Accelerate Contracts

This directory contains runtime-neutral machine contracts owned by Accelerate.
Runtime adapters consume these contracts; they do not redefine them.

## Hardened Execution Packet

`hardened-execution-packet.schema.json` describes the packet used for ambiguous,
risky, or otherwise non-trivial work. DSH is the first consumer. The packet is
not required for conversational turns or clear trivial work, which uses the
compact branch entry contract instead.

Validate an instance with:

```bash
python3 scripts/validate-hardened-execution-packet.py packet.json
```

The validator reports paths and safe reasons only. It never includes rejected
values in diagnostics.
