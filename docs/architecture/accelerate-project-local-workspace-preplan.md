# `.accelerate/` Project-Local Workspace Pre-Plan

## Branch Entry Packet

- classificação: `non-trivial`
- branch ativa: `project-local accelerate workspace model`
- skills ativas: `accelerate`, `architecture`, `writing-plans`
- fase / SDLC: `pré-planejamento / modelagem de produto`
- status do issue stack: `discussão inicial; sem mutação`
- single-threaded exception: `análise arquitetural deliberada`

Sim. A ideia de uma pasta **`.accelerate/` dentro do projeto alvo** faz muito
sentido, e provavelmente é a peça que falta para o `accelerate` deixar de ser
apenas “control plane global” e passar a ser também um **sistema que se instala
operacionalmente em cada repositório**.

Hoje o problema que você descreveu é real:

- o `accelerate` já sabe raciocinar sobre onboarding
- já sabe produzir plano executivo
- já sabe sugerir adapters, profiles e future agents
- mas ainda falta uma **superfície local persistida no projeto do usuário**
- sem isso, muito da verdade do onboarding fica:
  - na memória da sessão
  - em docs difusas
  - ou em artefatos não claramente “do projeto para o accelerate”

A pasta `.accelerate/` resolve exatamente isso.

---

## Tese

O `accelerate` precisa operar em **dois planos ao mesmo tempo**:

1. **plano do produto `accelerate`**
- o repositório standalone onde mora a doutrina, arquitetura, adapters,
  profiles, onboarding model, agent-factory

2. **plano de instalação local por projeto**
- a pasta `.accelerate/` dentro do projeto que está sendo governado

Sem essa segunda camada, o `accelerate` continua forte como framework, mas
fraco como sistema persistente de uso em um repositório real.

Então a formulação correta é:

- o repo `accelerate` é a **casa do produto**
- a pasta `.accelerate/` é a **instância local do produto dentro de um projeto**

---

## O que a `.accelerate/` deveria ser

Ela não deve ser um dump aleatório de notas.

Ela deve ser o **workspace operacional local do accelerate dentro do projeto**.

Ou seja, um lugar onde o próprio `accelerate` consiga:

- descobrir o estado local do onboarding
- saber o que já foi decidido
- saber o que ainda está em aberto
- persistir o workflow do setup do próprio accelerate naquele projeto
- deixar handoffs claros para futuras sessões
- guardar artefatos do projeto que são do `accelerate`, não do produto do
  usuário

---

## Problemas que a `.accelerate/` resolve

### 1. Onboarding inicial

Quando o `accelerate` entra num projeto vazio ou semi-vazio, ele precisa
decidir:

- qual workflow backend usar
- qual stack profile usar
- quais runtime adapters ativar
- qual docs posture usar
- quais skills recomendar
- se há gap claro de future agent

Sem `.accelerate/`, isso tende a virar conversa efêmera.
Com `.accelerate/`, isso vira estado persistido.

### 2. Reentrada

Numa sessão futura, o `accelerate` precisa responder rapidamente:

- esse repo já foi onboarded?
- em que fase está?
- qual foi o último plano executivo?
- qual profile foi escolhido?
- quais assumptions ainda estão válidas?
- o onboarding foi concluído ou está parcial?

### 3. Workflow do próprio setup

O setup do `accelerate` dentro do projeto também é trabalho de engenharia.

Logo ele precisa de:
- estado
- etapas
- planos
- checkpoints
- artifacts

A `.accelerate/` vira a casa disso.

### 4. Artefatos que não são globais

Existe uma diferença importante entre:
- verdade global do produto `accelerate`
- verdade local de um projeto específico governado por ele

A `.accelerate/` é onde vive a segunda.

---

## Princípio arquitetural

A `.accelerate/` deve ser tratada como:

- **workspace local de controle**
- **não** como parte do source code do produto do usuário
- **não** como substituto do `AGENTS.md`
- **não** como substituto do `.claude/napkin.md`
- **não** como dump de runtime arbitrário

Ela é um **estado de instalação e governança local do accelerate**.

---

## Relação com outros arquivos do projeto

### `AGENTS.md`
Continua sendo contrato de execução para sessões.

### `.claude/napkin.md`
Continua sendo runbook durável do repo.

### `.accelerate/`
Passa a ser a superfície local do produto `accelerate` dentro do repo.

Em uma frase:
- `AGENTS.md` diz **como operar**
- `napkin` diz **o que é recorrente e importante**
- `.accelerate/` diz **em que estado o projeto está perante o accelerate**

---

## Modelo mental correto

Pense assim:

- repositório `accelerate`
  - doutrina, arquitetura, profiles, adapters, onboarding system

- repositório do usuário
  - código do produto dele
  - `AGENTS.md`
  - `.claude/napkin.md`
  - `.accelerate/` como instalação local do accelerate

Então `.accelerate/` seria quase como:
- `workspace instance`
- `control-plane local state`
- `project-specific accelerate memory`

---

## Estrutura candidata da `.accelerate/`

Eu começaria assim:

```text
.accelerate/
├── README.md
├── state.yaml
├── onboarding/
│   ├── status.yaml
│   ├── discovery.yaml
│   ├── decisions.yaml
│   └── executive-bootstrap-plan.md
├── workflow/
│   ├── adapter.yaml
│   ├── conventions.yaml
│   └── mapping.md
├── profiles/
│   ├── active-profile.yaml
│   └── local-overrides.yaml
├── runtime/
│   ├── adapters.yaml
│   ├── capabilities.yaml
│   └── proof-posture.yaml
├── planning/
│   ├── current-plan.md
│   ├── history/
│   └── open-questions.md
├── agents/
│   ├── status.yaml
│   ├── candidates.yaml
│   ├── gaps.yaml
│   └── promotion-readiness.md
└── memory/
    ├── decisions-log.md
    ├── assumptions.md
    └── repo-signals.md
```

---

## O que cada bloco faria

## 1. `.accelerate/README.md`

Arquivo humano.

Explica:
- o que é essa pasta
- o que é canônico ali dentro
- o que é derivado
- o que pode ser reescrito pelo `accelerate`
- o que outra sessão deve ler primeiro

## 2. `state.yaml`

Estado resumido da instalação local.

Exemplo de campos:
- `accelerate_stage`
- `project_onboarded`
- `workflow_backend_status`
- `active_profile`
- `active_runtime_adapters`
- `agent_mode`
- `last_bootstrap_update`
- `last_executive_plan`

Esse arquivo é valioso porque permite uma leitura rápida por máquina e por
sessão.

## 3. `onboarding/`

Estado do onboarding do projeto.

### `status.yaml`
- `not_started`
- `in_progress`
- `partially_stabilized`
- `completed`
- `needs_reentry`

### `discovery.yaml`
Sinais observados:
- linguagem
- framework
- backend
- frontend
- docs posture
- ci/cd
- workflow tools
- package managers
- runtime evidence tools

### `decisions.yaml`
Decisões tomadas:
- workflow adapter escolhido
- profile escolhido
- adapters ativos
- docs posture
- non-goals

### `executive-bootstrap-plan.md`
O primeiro plano executivo local do repo.

## 4. `workflow/`

A casa da postura de workflow do projeto.

### `adapter.yaml`
Qual backend foi escolhido:
- `github`
- `linear`
- `none-yet`
- futuro `jira`

### `conventions.yaml`
Mapeamentos locais:
- labels
- statuses
- issue taxonomy
- fechamento
- review markers

### `mapping.md`
Explicação humana dessas convenções.

Isso conversa diretamente com a sua ideia de ter `linear` e `github` como
adapters equivalentes com a mesma arquitetura conceitual.

## 5. `profiles/`

Define o profile ativo e os overrides locais.

### `active-profile.yaml`
Exemplo:
- `django-inertia-react`
- `nextjs-tailwind`

### `local-overrides.yaml`
Porque um projeto real sempre tem pequenas diferenças:
- package manager diferente
- docs adapter desligado
- runtime adapter adicional
- convenção local de prova

## 6. `runtime/`

Estado dos adapters concretos no projeto.

### `adapters.yaml`
Quais adapters estão ativos:
- `python-uv`
- `node`
- `chrome-devtools`
- `playwright`

### `capabilities.yaml`
Quais capabilities o projeto já suporta localmente:
- tests
- lint
- browser truth
- e2e persistence
- docs build
- typecheck

### `proof-posture.yaml`
Postura atual de prova:
- mínimo exigido
- fallback
- quando browser truth é obrigatório
- quando persistent regression é obrigatório

## 7. `planning/`

Isso é extremamente importante.

Essa pasta seria a instância local da camada `planning` do produto
`accelerate`.

### `current-plan.md`
Plano em vigor para o próximo ciclo.

### `history/`
Planos anteriores importantes.

### `open-questions.md`
Ambiguidades de alto impacto ainda em aberto.

Aqui vemos claramente que sua intuição sobre “plano executivo como parte da
estratégia de programação” vira persistência local real.

## 8. `agents/`

Mesmo em pre-agents, isso já faz sentido.

### `status.yaml`
- `pre-agents`
- `root-only`
- `agent-eligible`
- `promotion-discussion-open`

### `candidates.yaml`
Possíveis families relevantes para esse projeto.

### `gaps.yaml`
Gaps detectados no contexto desse projeto específico.

### `promotion-readiness.md`
Análise se já faz sentido avançar para agents reais naquele repo.

Isso permite que o `accelerate` pense “por projeto”, não só “por framework”.

## 9. `memory/`

Esse bloco evita reescavação constante.

### `decisions-log.md`
Decisões importantes do projeto perante o `accelerate`.

### `assumptions.md`
Assumptions ainda válidas.

### `repo-signals.md`
Observações recorrentes sobre o repositório:
- é mono ou multiapp
- usa issue backend X
- docs são Y
- runtime truth depende de Z

---

## Formato dos arquivos

Eu recomendo misturar dois tipos:

### YAML para estado operacional
Bom para:
- leitura por máquina
- check rápido de fase
- adapters ativos
- profile escolhido
- status do onboarding

### Markdown para artefatos explicativos
Bom para:
- planos
- rationale
- decisões
- handoffs
- open questions

Então o modelo ideal é híbrido:
- `.yaml` para estado
- `.md` para raciocínio e handoff

---

## Quando a `.accelerate/` deve ser criada

Eu faria a regra assim:

### criar automaticamente quando:
- o `accelerate` é chamado em contexto de engenharia real
- e o repo ainda não tem `.accelerate/`

### não criar automaticamente quando:
- a interação foi só conversa exploratória
- não houve onboarding real
- não houve plano executivo
- não houve decisão persistível

Ou seja:
- ela surge no primeiro onboarding real
- não no primeiro “oi”

---

## Fluxos possíveis

## Fluxo A: projeto greenfield
1. usuário chama `accelerate`
2. `accelerate` detecta que não existe `.accelerate/`
3. entra em onboarding
4. produz discovery
5. produz decisões
6. produz plano executivo bootstrap
7. escreve `.accelerate/`

## Fluxo B: projeto existente sem `.accelerate/`
1. usuário chama `accelerate`
2. `accelerate` detecta repo maduro mas sem instalação local
3. roda onboarding de adoção
4. produz snapshot do estado atual
5. decide profile / adapters / docs posture
6. grava `.accelerate/`

## Fluxo C: projeto já onboarded
1. `accelerate` entra
2. lê `.accelerate/state.yaml`
3. lê `onboarding/status.yaml`
4. lê `planning/current-plan.md`
5. continua de onde o repo parou

## Fluxo D: reentrada por mudança estrutural
1. stack mudou
2. workflow backend mudou
3. docs posture mudou
4. entra em `needs_reentry`
5. reexecuta onboarding parcial
6. atualiza `.accelerate/`

---

## Como controlar o que foi feito no setup do próprio accelerate

Esse é um dos melhores pontos da sua ideia.

Hoje isso pode ficar implícito.
Com `.accelerate/`, dá para ter um verdadeiro **workflow persistido do setup do
accelerate**.

Exemplo:
- onboarding iniciado
- discovery concluído
- profile escolhido
- workflow adapter ainda pendente
- runtime adapters ativos
- plano bootstrap emitido
- pending slices ainda abertos
- pre-agents ainda vigente

Ou seja: o próprio `accelerate` passa a ter **estado operacional local do seu
deploy no projeto**.

---

## Como isso conversa com agents ou subagentes

Muito bem.

Porque uma future skill ou subagente de onboarding poderia:

- ler `.accelerate/state.yaml`
- saber se onboarding já ocorreu
- saber em que fase está
- descobrir o profile ativo
- saber se deve rodar discovery completa ou parcial
- atualizar só a parte relevante

Isso torna os agents mais previsíveis.

Sem `.accelerate/`, cada subagente depende muito mais de contexto implícito.

---

## Como isso conversa com o repo standalone do accelerate

A relação correta seria:

- repo `accelerate`
  - define a estrutura e o contrato da `.accelerate/`

- projeto do usuário
  - contém uma instância concreta da `.accelerate/`

Ou seja:
- o produto define o schema
- cada projeto guarda seu estado local

---

## Precisa versionar a `.accelerate/` no git do projeto?

Essa é uma decisão crítica.

Minha leitura:

## o núcleo da `.accelerate/` deve ser commitável
Porque ele representa:
- decisões de setup
- profile
- workflow adapter
- runtime posture
- planos executivos relevantes
- memória de governança do projeto

Isso é trabalho de equipe, não cache local.

## mas parte dela pode ser ignorada
Talvez uma futura subpasta como:

```text
.accelerate/runtime/
.tmp/
.accelerate/cache/
```

Ou seja:
- **estado canônico**: commitável
- **cache efêmero**: ignorado

Minha sugestão:
- começar tudo commitável
- só depois separar caches se surgirem de verdade

---

## Riscos

## 1. Virar dumping ground
Se `.accelerate/` não tiver contrato, vira bagunça.

Mitigação:
- schema claro
- subpastas nomeadas
- distinção entre estado, plano, memória e cache

## 2. Duplicar `AGENTS.md` e `napkin`
Mitigação:
- papéis explícitos
- `AGENTS.md` = contrato de sessão
- `napkin` = runbook durável
- `.accelerate/` = estado local do deploy do accelerate

## 3. Poluir o repo do usuário
Mitigação:
- estrutura limpa
- poucos arquivos canônicos
- nada de gerar 30 arquivos na primeira rodada

## 4. Acoplamento excessivo ao estágio atual
Mitigação:
- projetar a `.accelerate/` com versionamento de schema
- ex.: `schema_version: 1`

## 5. Misturar produto e projeto
Mitigação:
- não escrever doutrina do `accelerate` dentro da `.accelerate/`
- ali só vive a instância local do projeto

---

## Minha proposta de MVP

Eu não começaria com a estrutura completa.

Começaria com um MVP muito forte e pequeno:

```text
.accelerate/
├── README.md
├── state.yaml
├── onboarding/
│   ├── status.yaml
│   ├── discovery.yaml
│   ├── decisions.yaml
│   └── executive-bootstrap-plan.md
├── planning/
│   ├── current-plan.md
│   └── open-questions.md
└── agents/
    ├── status.yaml
    └── gaps.yaml
```

Isso já resolve o principal:
- onboarding
- persistência
- plano executivo
- estado pre-agents
- gaps locais

Depois evolui.

---

## MVP de `state.yaml`

Algo assim:

```yaml
schema_version: 1
accelerate_stage: standalone-pre-agents
project_onboarded: true
onboarding_status: partially_stabilized
workflow_backend: none-yet
active_profile: django-inertia-react
active_runtime_adapters:
  - python-uv
  - node
  - chrome-devtools
  - playwright
agent_mode: root-only
last_bootstrap_update: 2026-04-15
current_plan: .accelerate/planning/current-plan.md
```

---

## O que isso mudaria no accelerate como produto

Bastante.

O `accelerate` deixaria de ser só:
- um root skill
- um conjunto de doutrina
- um framework de onboarding

E passaria a ser também:
- um **sistema instalável em repositórios**
- com **estado local persistido**

Isso é um salto real de maturidade.

---

## Minha leitura final

Sua ideia é boa e, mais que isso, **necessária**.

Sem `.accelerate/`, o `accelerate` continua poderoso, mas incompleto como
sistema operacional real por projeto.

Com `.accelerate/`, ele ganha:
- memória local
- persistência de onboarding
- continuidade entre sessões
- base concreta para future agents/subagentes
- espaço próprio para artefatos do workflow do accelerate no projeto

---

## Pre-plan recomendado

Eu trataria isso como uma discussão ainda inicial, então o pre-plan correto
seria:

1. **instituir a ideia da `.accelerate/` como workspace local do produto**
2. **definir o contrato mínimo do MVP**
3. **definir o que é commitável vs efêmero**
4. **definir o fluxo de criação em greenfield e adoção em projeto existente**
5. **definir como `AGENTS.md`, `napkin` e `.accelerate/` se relacionam**
6. **só depois implementar a primeira versão do schema**

Se você quiser, o próximo passo pode ser exatamente esse: eu transformo esta
discussão em um **plano executivo formal da `.accelerate/`** dentro do repo
`accelerate`, ainda sem implementar.

## Follow-up

The executive-plan variants created from this pre-plan now live in:

- `docs/architecture/accelerate-project-local-workspace-executive-plans.md`
- `docs/architecture/accelerate-project-local-workspace-executive-plan-v1-minimum-extreme.md`
- `docs/architecture/accelerate-project-local-workspace-executive-plan-v2-small-and-useful.md`
- `docs/architecture/accelerate-project-local-workspace-executive-plan-v3-broad-local-control-surface.md`
