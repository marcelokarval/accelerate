# Architecture Documentation

Este diretório contém a documentação arquitetural, decisões formais de design (ADRs), especificações técnicas de subsistemas (SDDs) e análises de baseline da plataforma **Accelerate**.

---

## Estrutura do Diretório

```text
docs/architecture/
├── adr/                         # Architectural Decision Records (Decisões Formais)
│   ├── 2026-09-18-adr-001-opencode-plugin-hardening.md
│   └── 2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md
├── sdd/                         # Software Design Documents (Especificações Detalhadas)
│   └── 2026-09-18-sdd-v032-harness-hardening.md
├── accelerate-control-plane.md  # Arquitetura do control plane soberano
├── accelerate-sdd-v1.md         # SDD fundamental v1
├── dense-dispatch-and-caveman-protocol.md # Protocolo de comunicação Master-Worker
└── ...
```

---

## Architectural Decision Records (ADRs)

Os ADRs registram decisões técnicas fundamentais, trade-offs analisados e as justificativas para escolhas de design:

- **[ADR 001: OpenCode Plugin Hardening, Envelope Provenance & Role Sandboxing](adr/2026-09-18-adr-001-opencode-plugin-hardening.md)**
  - Define o isolamento de prompts, supressão segura de superpowers via parsing AST/delimitado, hashing canônico RFC 8785 (JCS) de envelopes e sandboxing estrito de ferramentas por papel.

- **[ADR 002: Portable Accelerate Operational Integration Boundary](adr/2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md)**
  - Define a soberania metodológica inegociável do Accelerate (escopo, critérios, planejamento proporcional, revisão, prova e aceite).
  - Estabelece o papel de tradução neutra dos adaptadores de runtime (`adapters/runtime/*`), sem poluição de nomes de ferramentas, portas locais ou identificadores de providers no core.
  - Formaliza o desacoplamento de complementos operacionais (como `accelerate-omo-plugin`): o plugin provê infraestrutura auxiliar; o hospedeiro (ex: OmO/OpenCode) permanece o orquestrador; o plugin não define requisitos de produto nem exige cerimônias inflacionadas (ex: 9 fases) para tarefas simples.
  - Delimita a topologia `Master -> Workers-Sessões (Worktrees) -> Subagentes Locais`, com proibição de herança de autoridade de fechamento (`Done`) por subagentes e verificação de capacidades por adaptador.
  - Garante a cadeia causal e coerência documental `PRD -> ADR -> SDD -> Tasks` (tasks nunca reescrevem requisitos de produto).
  - Impõe a tripartição estrita dos três grafos: Especificação ($G_{spec}$), Execução ($G_{exec}$) e Evidências/Invalidação ($G_{proof}$).
  - Define regras de anti-fragmentação (interfaces versionadas, consumo explícito, proibição de cópia de doutrina em mini-skills avulsas e banimento de caminhos absolutos como contrato).
  - Diferencia explicitamente dívida técnica de código em `adapters/runtime/opencode/accelerate-plugin.js` de ativação física/operacional no host (a mera presença do arquivo não equivale a plugin ativo).
  - Cataloga os defeitos identificados na auditoria v0.3.2 como trabalho interno prioritário do Accelerate.
  - Padroniza o ponto de integração futuro via `Dense-Dispatch Skeleton YAML v1` (entrada) e `Caveman Return v1` (saída).

---

## Software Design Documents (SDDs)

- **[SDD v0.3.2: Harness Hardening & Envelope Integrity](sdd/2026-09-18-sdd-v032-harness-hardening.md)**
  - Detalha a implementação física do hook `experimental.chat.messages.transform` do OpenCode, a máquina de estados para parsing delimitado, as rotinas de verificação de hash canônico e a matriz de tratamento de erros.

---

## Documentos Fundamentais de Arquitetura

- **[Accelerate Control Plane](accelerate-control-plane.md)**: Governança soberana, matriz de enforçamento e ciclo de vida de mutação.
- **[Accelerate SDD v1](accelerate-sdd-v1.md)**: Especificação canônica de interfaces e modelos do core.
- **[Dense-Dispatch and Caveman Protocol](dense-dispatch-and-caveman-protocol.md)**: Racional de economia de tokens e comunicação de alta densidade semântica entre Master e Workers.
- **[Zero-Waste Dispatch & Readiness Pipeline](zero-waste-dispatch-and-readiness-pipeline.md)**: Pipeline de preparação e prontidão de tarefas sem overhead de contexto.
- **[OpenChamber Runtime Adapter Proposal](openchamber-runtime-adapter-proposal.md)**: Proposta de integração e adaptação para o runtime OpenChamber.
