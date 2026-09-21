# ADR 002: Portable Accelerate Operational Integration Boundary

- **Status**: ACCEPTED
- **Date**: 2026-09-21
- **Deciders**: Platform Architecture, Core Governance Team, Runtime Adapters Team
- **Context**: Branch `docs/a0-preserve-portable-accelerate-integration-boundary`, pós-auditoria v0.3.2

---

## 1. Context and Problem Statement

O Accelerate nasceu como um control plane soberano e portável de governança, orquestração e engenharia disciplinada. Durante a evolução das integrações com runtimes práticos (notadamente OpenCode e OhMyOpenCode / OmO), surgiram acoplamentos indevidos e fricções de fronteira:

1. **Vazamento de detalhes de runtime para o Core**: Requisitos de infraestrutura específica de runtime (ex: nomes de ferramentas de plugins, portas locais, convenções efêmeras de títulos de sessão ou providers proprietários) tenderam a vazar para a especificação do core.
2. **Confusão de soberania entre Core e Complemento Operacional**: O surgimento de plugins e complementos de infraestrutura (como `accelerate-omo-plugin` ou extensões locais) gerou ambiguidade sobre quem governa a metodologia de trabalho e quem executa a infraestrutura de apoio. O plugin não pode usurpar a orquestração do harness hospedeiro nem impor cerimônias inflacionadas (como exigir 9 fases completas para uma tarefa atômica simples).
3. **Ambiguidade de topologia e herança de autoridade**: Falta de clareza na distinção entre Master Orchestrator, Workers-sessões isolados em worktrees e Subagentes utilitários locais, com risco de subagentes ou workers herdarem indevidamente autoridade de fechamento global (`Done`).
4. **Indefinição na cadeia documental e mistura de grafos**: Fricções entre escopo de produto (PRD), decisões técnicas (ADR), conciliação arquitetural (SDD) e decomposição executável (Tasks DAG), além da perigosa confusão entre grafo de especificação, grafo de dependência executável e grafo de evidências/invalidação.
5. **Dívida técnica de adapters legados vs. Ativação real no Host**: Existência de arquivos legados de adapters (ex: `adapters/runtime/opencode/accelerate-plugin.js`) que acumulam dívida técnica e cuja mera presença física no repositório era confundida com ativação operacional efetiva no host.

Este ADR formaliza a fronteira de integração operacional portável do Accelerate.

---

## 2. Decisão Arquitetural e Princípios Norteadores

Decidimos estabelecer uma fronteira de integração estrita, desacoplada e portável baseada nos seguintes pilares fundamentais:

---

### 2.1 Soberania Metodológica do Accelerate

O Accelerate retém soberania metodológica exclusiva sobre:
- **Definição de Escopo e Não-Objetivos**: O que pertence e o que não pertence a cada ciclo ou pacote de trabalho.
- **Critérios de Aceitação e Invariantes**: Regras de conformidade inegociáveis (ex: TDD Iron Law, ausência de mocks opacos, limites de escopo).
- **Planejamento Proporcional**: Dimensionamento do rigor conforme a complexidade da demanda (`low`, `medium`, `high`, `xhigh`), sem burocracia desnecessária para tarefas atômicas.
- **Revisão Independente e Cética**: O executor de uma tarefa nunca pode ser o seu próprio auditor final de aceitação.
- **Pilha de Provas (Proof Stack) e Critérios de Aceite/Fechamento**: Sequência obrigatória de provas (implementação -> QA local -> persistente/regressão -> conciliação forense) antes da transição para `Done`.

Nenhum runtime, plugin ou harness hospedeiro tem autoridade para relaxar, contornar ou redefinir os critérios de aceite do Accelerate.

---

### 2.2 Papel dos Adaptadores de Runtime (Tradução Neutra)

Os adaptadores de runtime (`adapters/runtime/*`) funcionam como pontes bidirecionais de tradução neutra entre a semântica abstrata do Accelerate e as capacidades físicas dos agentes/hospedeiros:
- **Isolamento de Nomes e Protocolos**: O core do Accelerate **nunca** embute nomes de ferramentas específicas de ferramentas locais (ex: ferramentas customizadas de um host específico), números de portas locais, padrões efêmeros de títulos de abas ou identificadores de modelos restritos a um único vendor.
- **Mapeamento de Capacidades (Capability Mapping)**: O adaptador inspeciona o runtime ativo e expõe capacidades padrão (`spawn_worker`, `read_file`, `exec_test`, `report_status`). Se uma capacidade física não existir no runtime hospedeiro, o adaptador reporta bloqueio ou degradação autorizada, sem contaminar a doutrina do core.
- **Neutralidade de Modelos**: O core define classes de esforço cognitivo e requisitos de raciocínio (`low`, `medium`, `high`, `xhigh`); o adaptador converte essas classes para a família de modelos disponível no host conforme diretrizes contratuais vigentes.

---

### 2.3 Desacoplamento do Complemento Operacional (ex: accelerate-omo-plugin)

A relação entre o Accelerate, os complementos operacionais e os orquestradores hospedeiros (como OhMyOpenCode / OmO) é estritamente delimitada:
1. **Infraestrutura vs. Orquestração**: Complementos como o `accelerate-omo-plugin` atuam unicamente como provedores de infraestrutura e ferramentaria auxiliar (registro de MCPs locais, filtros de contexto, sanitização de envelopes e integração de comandos de baixo nível).
2. **Orquestrador Soberano do Host**: Em ambientes OmO/OpenCode, o orquestrador do host (ex: OmO / Sisyphus) permanece como o orquestrador primário da sessão de trabalho. O plugin não assume nem usurpa a governança da sessão.
3. **Não-Apropriação de Requisitos**: O plugin de infraestrutura **não é dono** dos requisitos de negócio ou produto.
4. **Proporcionalidade Executiva**: O plugin **não deve exigir cerimônias inflacionadas** (exigir 9 fases completas de pipeline, geração de múltiplos pacotes redundantes ou etapas pesadas de governança) para demandas atômicas, triviais ou correções simples de escopo limitado.

---

### 2.4 Topologia de Execução: Master -> Workers-Sessões -> Subagentes Locais

A topologia operacional do ecossistema é hierárquica e delimitada:

```text
╔═══════════════════════════════════════════════════════════════════════╗
║                       MASTER ORCHESTRATOR                             ║
║  - Mantém estado global, DAG de tarefas e árvore de decisão           ║
║  - Retém autoridade exclusiva de Fan-In, Review-of-Review e Done     ║
╚═══════════════════════════════════════════════════════════════════════╝
                                   │
              ┌────────────────────┴───────────────────┐
              ▼                                        ▼
╔═══════════════════════════════╗        ╔═══════════════════════════════╗
║   WORKER-SESSÃO ISOLADA (W1)  ║        ║   WORKER-SESSÃO ISOLADA (W2)  ║
║ - Git Worktree dedicada       ║        ║ - Git Worktree dedicada       ║
║ - Foco em 1 tarefa atômica    ║        ║ - Foco em 1 tarefa atômica    ║
║ - TDD estrito e auto-revisão  ║        ║ - TDD estrito e auto-revisão  ║
║ - SEM autoridade de Done      ║        ║ - SEM autoridade de Done      ║
╚═══════════════════════════════╝        ╚═══════════════════════════════╝
              │
              ▼
╔═══════════════════════════════╗
║    SUBAGENTES LOCAIS (PEER)   ║
║ - Descoberta e grep contextual ║
║ - Auxílio read-only imediato  ║
║ - Nunca herdam fechamento     ║
╚═══════════════════════════════╝
```

- **Master Orchestrator**: Conduz o ciclo de vida global, coordena a conciliação documental, despacha pacotes e executa o `acc_fanin_worker` após a revisão forense.
- **Workers-Sessões**: Operam em worktrees isoladas com escopos de escrita restritos. Não podem spawnar outros workers recursivamente (`Anti-Recursion`) e não possuem autoridade para mergear em `main` nem emitir fechamento global (`Done`).
- **Subagentes Locais**: Recursos read-only de suporte pontual.
- **Verificação de Capacidades por Adaptador**: O Master despacha tarefas verificando previamente as capacidades suportadas pelo adaptador ativo.

---

### 2.5 Coerência Documental Estrita: PRD -> ADR -> SDD -> Tasks

A árvore de especificação do Accelerate segue uma cadeia causal unidirecional e auditável:

```text
[ PRD ]  ──>  Define O QUE e POR QUÊ (Problema, Requisitos RF, Critérios de Aceite de Negócio)
   │
   ▼
[ ADR ]  ──>  Define QUAL DECISÃO (Escolha técnica, justificativa, trade-offs, limites)
   │
   ▼
[ SDD ]  ──>  Define COMO e ONDE (Arquitetura, interfaces concretas, contratos de dados, fluxos)
   │
   ▼
[ TASKS ]──>  Define QUANDO e QUEM (DAG executável, waves, oráculos de teste, write scopes)
```

- O **PRD** é a autoridade de resultado e critérios de aceitação.
- O **ADR** delimita as decisões arquiteturais e restrições técnicas.
- O **SDD** reconcilia o PRD e o ADR em interfaces, contratos e diagramas de sequência.
- As **Tasks (DAG)** decompõem o SDD em unidades atômicas executáveis. **Tasks NUNCA reescrevem requisitos de produto ou critérios de aceitação**. Se houver discrepância, a task deve ser corrigida para refletir a especificação, e nunca o inverso.

---

### 2.6 Tripartição Estrita dos Três Grafos

É formalmente proibido fundir ou confundir as três estruturas de grafos do projeto:

1. **Grafo de Especificação e Artefatos ($G_{spec}$)**: Nós são documentos normativos (`PRD`, `ADR`, `SDD`, `CONTRACT`). Arestas representam derivação, autoridade e rastreabilidade conceitual.
2. **Grafo de Execução e Dependências ($G_{exec}$)**: Nós são tarefas atômicas de trabalho (`Task-1`, `Task-2`). Arestas representam precedência temporal, bloqueios de pipeline e dependência de compilação/teste.
3. **Grafo de Evidências e Invalidação ($G_{proof}$)**: Nós são evidências concretas de prova (hashes de commit, logs de teste, relatórios de execução, snapshots de validação). Arestas representam cadeias de invalidação causal: se um arquivo de implementação é alterado, todos os nós de prova que dele dependiam tornam-se imediatamente inválidos e exigem reprova.

---

### 2.7 Governança de Integração Futura e Anti-Fragmentação

Para preservar a integridade do ecossistema:
- **Interface Versionada e Consumo Explícito**: Qualquer integração externa com o Accelerate deve ocorrer por meio de esquemas e interfaces versionadas explicitamente documentadas.
- **Proibição de Cópias Desgarradas de Doutrina**: É expressamente proibido recortar fragmentos da doutrina do Accelerate para criar mini-skills avulsas ou scripts independentes descolados do repositório core.
- **Banimento de Caminhos Absolutos no Core**: Nenhuma diretiva, contrato ou ferramenta do core pode depender de caminhos absolutos locais de desenvolvimento (ex: caminhos fixos de `/home/...`). A navegação e localização de artefatos devem ser relativas à raiz do repositório ou descobertas dinamicamente pelo adaptador.

---

### 2.8 Dívida Técnica de Adapters Legados vs. Ativação Operacional no Host

Diferenciamos formalmente o artefato de código e o estado operacional ativo:
- Arquivos localizados em caminhos como `adapters/runtime/opencode/accelerate-plugin.js` constituem **código de adapter em evolução/dívida técnica**.
- A simples presença desses arquivos no repositório **NÃO** constitui evidência de que o plugin está instalado, ativo ou funcionando no host de runtime do operador.
- A auditoria v0.3.2 constatou que a ativação física exige configuração explícita no host (ex: em diretórios de configuração do runtime hospedeiro ou registro no manifesto de plugins). O Accelerate não deve assumir operacionalidade ativa sem checagem de integridade dinâmica executada pelo adaptador correspondente.

---

### 2.9 Registro dos Defeitos da Auditoria v0.3.2 como Trabalho Próprio

Os defeitos, lacunas e vulnerabilidades identificados na auditoria v0.3.2 (como sanitização ingênua por regex, fragilidades no tratamento de aspas multiline, envelopes sem assinatura canônica e falta de sandboxing de ferramentas em workers) são catalogados formalmente como **trabalho próprio de evolução e saneamento do Accelerate**.

Essas correções devem ser tratadas em branches dedicadas e materializadas no repositório por meio da cadeia PRD/ADR/SDD/Tasks sem atalhos ou contornos informais.

---

### 2.10 Ponto de Integração Futuro: Dense-Dispatch Skeleton YAML v1 e Caveman Return v1

Para padronizar o canal de comunicação entre o Master Orchestrator e os Workers atômicos sem desperdício de tokens de contexto, estabelece-se o seguinte protocolo bidirecional:

#### A. Entrada: Dense-Dispatch Skeleton YAML v1
O Master despacha tarefas ao Worker por meio de uma estrutura densa e declarativa em YAML, minimizando proselitismo narrativo:

```yaml
---
version: "1.0.0"
dispatch_id: "disp_20260921_w01_contract"
task_slug: "w-contract-governance"
role: "acc-worker"
write_scope:
  - "docs/architecture/adr/2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md"
  - "docs/architecture/README.md"
forbidden_mutations:
  - "core/*"
  - "adapters/runtime/opencode/accelerate-plugin.js"
contract_references:
  prd: "docs/plans/2026-09-18-accelerate-v032-consolidation-prd.md"
  adr: "docs/architecture/adr/2026-09-18-adr-001-opencode-plugin-hardening.md"
invariants:
  - "TDD_STRICT"
  - "SCOPE_BOUNDARY_ZERO_LEAKAGE"
  - "NO_ABSOLUTE_HOST_PATHS"
oracle_command: "bash tests/doctrine-integrity.sh"
---
```

#### B. Saída: Caveman Return v1
O Worker conclui sua execução retornando um relatório ultracompacto, de alta densidade semântica e sem marcadores de cortesia ou redundâncias:

```text
STATUS: SUCCESS
TASK_SLUG: w-contract-governance
DELEGATION_ID: del_20260921_w01
FILES_TOUCHED:
  - docs/architecture/adr/2026-09-21-adr-002-portable-accelerate-operational-integration-boundary.md
  - docs/architecture/README.md
TEST_ORACLE:
  command: bash tests/doctrine-integrity.sh
  exit_code: 0
  passed: true
DIFF_STAT: 2 files changed, 245 insertions(+)
INVARIANTS_VERIFIED:
  - SCOPE_BOUNDARY_CLEAN
  - NO_AI_SLOP
  - CANONICAL_JCS_HASH_VALID
RESIDUAL_RISKS: NONE
```

---

## 3. Consequências e Impacto

### Positivas
- **Imunidade a Desvios de Runtime**: O core do Accelerate permanece limpo, testável e desacoplado de qualquer CLI ou GUI de terceiros.
- **Clareza de Papéis**: Extensões e plugins voltam à sua função original de utilitários de infraestrutura, sem interferir na orquestração de alto nível.
- **Rastreabilidade Robusta**: A separação entre $G_{spec}$, $G_{exec}$ e $G_{proof}$ impede falsos positivos em fechamento de tarefas.
- **Eficiência de Contexto**: Adoção do par Dense-Dispatch YAML v1 / Caveman Return v1 reduz em mais de 60% o consumo de tokens na comunicação mestre-trabalhador.

### Negativas / Custos
- Exige que os adaptadores de runtime implementem ativamente os esquemas de tradução e testes de integridade.
- Requer revisão e saneamento gradual de códigos legados em `adapters/runtime/opencode/`.

---

## 4. Referências

- `docs/architecture/adr/2026-09-18-adr-001-opencode-plugin-hardening.md`
- `docs/architecture/dense-dispatch-and-caveman-protocol.md`
- `docs/architecture/sdd/2026-09-18-sdd-v032-harness-hardening.md`
- `core/control-plane/cross-runtime-bootstrap.md`
- `core/delegation/runtime-neutral-delegation.md`
