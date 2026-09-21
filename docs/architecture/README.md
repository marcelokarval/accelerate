# Architecture Documentation

Este diretório contém a documentação arquitetural, decisões formais de design (ADRs), especificações técnicas de subsistemas (SDDs) e análises de baseline da plataforma **Accelerate**.

---

## Estrutura do Diretório

```text
docs/architecture/
├── adr/                         # Architectural Decision Records (Decisões de Design)
│   ├── 2026-09-18-adr-001-opencode-plugin-hardening.md
│   └── 2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md
├── sdd/                         # Software Design Documents (Especificações Técnicas)
│   └── 2026-09-18-sdd-v032-harness-hardening.md
├── accelerate-control-plane.md  # Arquitetura do control plane
├── accelerate-sdd-v1.md         # SDD fundamental v1
├── dense-dispatch-and-caveman-protocol.md # Proposta de notação para despacho denso e retornos
└── ...
```

---

## Architectural Decision Records (ADRs)

- **[ADR 001: OpenCode Plugin Hardening, Envelope Provenance & Role Sandboxing](adr/2026-09-18-adr-001-opencode-plugin-hardening.md)**
  - Documento de design que estabelece diretrizes de sanitização de mensagens, mitigação de injeções redundantes e isolamento de contexto de execução por papel no plugin OpenCode.

- **[ADR 002: Portable Accelerate Operational Integration Boundary](adr/2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md)** *(ACCEPTED / decisão de design; integração pendente de implementação e qualificação)*
  - Registra a direção de separação entre o método portátil Accelerate e complementos operacionais de runtime (como `accelerate-omo-plugin`).
  - Estabelece que o Accelerate retém soberania metodológica quando selecionado, enquanto complementos operacionais gerenciam infraestrutura de sessões, worktrees e observabilidade sem competir pela governança de requisitos.
  - Define a topologia Master ➔ Workers-Sessões ➔ Subagentes, permitindo que subagentes executem pesquisas, implementação e verificações no slice atribuído, sem herdar autoridade de fechamento global (`Done`).
  - Formaliza a relação entre PRD, ADR, SDD e Tasks com suporte a feedback iterativo da execução e proporcionalidade de artefatos.
  - Diferencia dívida técnica de adapters no repositório (`adapters/runtime/opencode/`) de ativação física no host, mantendo o backlog de auditoria v0.3.2 como trabalho próprio do projeto.

---

## Software Design Documents (SDDs)

- **[SDD v0.3.2: Harness Hardening & Envelope Integrity](sdd/2026-09-18-sdd-v032-harness-hardening.md)**
  - Especificação de design para o tratamento de mensagens no hook de runtime e conformidade de envelopes de controle.

---

## Documentos Fundamentais de Arquitetura

- **[Accelerate Control Plane](accelerate-control-plane.md)**: Governança soberana, matriz de enforçamento e ciclo de vida de mutação.
- **[Accelerate SDD v1](accelerate-sdd-v1.md)**: Especificação canônica de interfaces e modelos do core.
- **[Dense-Dispatch and Caveman Protocol](dense-dispatch-and-caveman-protocol.md)**: Proposta arquitetural para otimização de entrada e saída em despachos multi-sessão.
- **[Zero-Waste Dispatch & Readiness Pipeline](zero-waste-dispatch-and-readiness-pipeline.md)**: Proposta de pipeline de preparação e prontidão sem redundância de descoberta.
- **[OpenChamber Runtime Adapter Proposal](openchamber-runtime-adapter-proposal.md)**: Proposta de integração e adaptação para o runtime OpenChamber.
