# Cadeia de Inteligência de Grafo, Memória e Engenharia Reversa (Zero Token Waste)

Esta especificação define o fluxo lógico e operacional da cadeia integrada de cartografia, observação e memória para o `accelerate`:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       REVERSA (Arqueologia / AST / De-drift)                │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 CODEGRAPH / CODEBASE-MEMORY-MCP (Index Local)               │
│               (SQLite AST Graph / Tree-Sitter / Symbol Cache)               │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    GRAPHIFY (Grafo de Conhecimento & Clusters)              │
│               (Comunidades, God Nodes, Traversal BFS/DFS)                   │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ARCHIFY (Modelagem Visual Determinística)               │
│               (IR Tipada -> Diagrama SVG/HTML Interativo Standalone)        │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ACCELERATE (Root Orchestration Control Plane)            │
│               (Zero-Waste Dispatch, Task Graph, Immutable Scopes)           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Princípio Fundamental: Proibição de "Blind Archaeology" e Desperdício de Tokens

Agentes e orquestradores frequentemente desperdiçam de 50.000 a 200.000 tokens executando loops repetitivos de `read`, `grep` e buscas manuais em repositórios médios ou grandes.
No `accelerate`, essa prática é classificada como **Blind Archaeology** e é proibida antes do dispatch.

A cadeia de grafo e memória transforma a descoberta passiva em **observação estruturada e indexada de custo quase zero**.

---

## 2. Papéis e Fluxo Lógico Passo a Passo

### Passo 1: Arqueologia e Desconstrução com `Reversa`
* **Quando atua**: No `Stage A: Semantic Pre-scan` e diante de código legado ou desconhecido com alto drift histórico.
* **Mecanismo**: Invocado em modo puramente read-only (`reversa-archaeologist`, `reversa-docs-mapper`).
* **Entregável**: Extrai contratos implícitos, acoplamento de serviços e rotas ocultas sem mutação.

### Passo 2: Indexação Estrutural com `codegraph` e `codebase-memory-mcp`
* **Quando atua**: Durante toda a sessão de trabalho e pré-planejamento.
* **Mecanismo**:
  * `codegraph` mantém um banco SQLite AST (`.codegraph/`) com resolução instantânea de chamadas, dependências e blast radius.
  * `codebase-memory-mcp` fornece persistência contextual cross-turn e cross-session, servindo trechos e relações via stdio sem releitura de arquivos.
* **Benefício**: Reduz em mais de 80% o número de chamadas de leitura de arquivos brutos.

### Passo 3: Clusterização e Síntese Semântica com `graphify`
* **Quando atua**: Antes de atingir o marco `TASKS_READY`.
* **Mecanismo**: Constrói o grafo em `graphify-out/graph.json`, identificando **God Nodes**, **Comunidades** e conexões surpreendentes entre módulos aparentemente isolados.
* **Entregável**: Geração do `GRAPH_REPORT.md` e permissão de queries direcionadas (`graphify query "<pergunta>"`) para validar seams (costuras) de arquitetura.

### Passo 4: Verificação Visual e Validação de Fronteiras com `archify`
* **Quando atua**: Na formalização do `Visual Modeling Packet` do plano executivo ou task-graph.
* **Mecanismo**: O `accelerate` emite uma IR tipada determinística (`workflow` ou `architecture`) e o compilador `archify` gera o diagrama SVG/HTML auto-contido.
* **Regra**: O diagrama não é autoridade de fato, mas é o validador visual mandatório de que o particionamento de tarefas não possui sobreposição ou loops bloqueantes.

### Passo 5: Decisão e Despacho no `Accelerate`
* **Resultado**: O Root Orchestrator injeta nos manifests dos subagentes apenas o **Bounded Context Manifest** exato (arquivos que possui, limites permitidos, seams proibidos e testes exigidos).
* Nenhum subagente precisa "explorar para descobrir onde mexer".

---

## 3. REGRA DE CUSTO MANDATÓRIA (DELEGAÇÃO E SUBAGENTES)

```text
=============================================================================
CRITICAL COST CONTROL MANDATE: ZERO CODEX ON SUBAGENTS
=============================================================================
```

Para garantir eficiência extrema de custos e aproveitar o contexto amplo sem estourar orçamento:

1. **PROIBIÇÃO DE CODEX**:
   * É terminantemente **PROIBIDO** instanciar subagentes ou sidecars com modelos da família Codex (`gpt-5.3-codex`, `codex-*`, etc.) para exploração, parsing de grafo ou execução mecânica.
2. **MODELO OBRIGATÓRIO PARA SUBAGENTES**:
   * Todo subagente instanciado pela cadeia de grafo/memória ou execução subordinada DEVE usar explicitamente:
     * **`model: google-agy/gemini-3.8-flash`** (Padrão para exploração, cartografia e tarefas rápidas)
     * **`model: google-agy/gemini-3.1-pro`** (Para síntese profunda de arquitetura e validação complexa)
3. **VARIANTE OBRIGATÓRIA**:
   * Todo despacho deve injetar explicitamente o parâmetro **`variant: high`**.
4. **ENFORCEMENT**:
   * O orquestrador central rejeitará qualquer task receipt emitido por subagente se o modelo de execução violar esta diretriz.
