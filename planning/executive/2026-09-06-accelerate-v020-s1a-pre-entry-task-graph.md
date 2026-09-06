# Accelerate v0.2.0 — grafo pré-entrada de S1A

## Estado e autoridade

Estado: `draft-pre-s1a`, planejamento somente. Issue canônica desta geração de
design: Plane `CODEX-31` / `e31850d4-275d-4ef1-a078-50c79ea60020`. Plane
continua sendo a única autoridade de lifecycle; este arquivo não atualiza o
item, não inicia S1A e não fecha `CODEX-26`.

Governing sources: `AGENTS.md`; SDD consolidado v0.2.0 aceito como design;
matriz de reconciliação; Contract v1 SDD, review index, master plan, Wave 0 e
catálogo. O baseline factual continua
`7c2966c5b86ceba9e4217c17b8fbbd1a90248a2e`; a entrada real deverá capturar
novamente `HEAD`, status e diff.

## Objetivo e não objetivos

Objetivo: deixar uma unidade S1A executável somente após freeze, revisão e
admissão, produzindo a emenda ACV1↔v0.2.0, o mapa requisito→disposição→wave e
guardas de conformance para R01.

Não objetivos: executar qualquer task ACV1-W0; criar/modificar
`core/contracts/v1/`; instalar/importar OpenSpec; alterar adapters, scheduler,
runtime, user-home, Hermes ou Plane; alegar benchmark de resolução de
problemas; encerrar `CODEX-26`; promover/release/merge.

## Denominador de unidades

Este denominador está em rascunho até revisão independente. IDs são estáveis
para esta geração; uma mudança de membership invalida a validação da DAG.

| ID | Resultado verificável | Owner/executor proposto | Escrita permitida | Prova planejada | Stop rule |
| --- | --- | --- | --- | --- | --- |
| P01 | revalidação de fontes e baseline | root, read-only | nenhuma | receipts de Git/Plane/OpenSpec | estado/commit/locator divergente. |
| P02 | emenda ACV1↔v0.2.0 e mapa de 24 decisões | root | `planning/architecture/` | tabela total, links e revisão | decisão sem disposição ou tentativa de alterar ACV1. |
| P03 | Test Design independente R01/ACV1 | QA independente | `planning/architecture/` | requirement→fixture→oracle | oráculo dependente da implementação ou escopo além R01. |
| P04 | addendum de dependências e denominator S1A congelado | root | `planning/executive/` | DAG válida e check de escopo | ciclo, ID duplicado ou tarefa sem gate. |
| P05 | fixtures/oráculos e teste red-first de autoridade | QA independente | `tests/fixtures/contract-v1-authority/`, teste focado | falha estável antes de qualquer guard | mudança em core/runtime ou red por infraestrutura. |
| P06 | guardas de precedência/conformance verdes | implementador delegado distinto | teste focal e paths S1A previamente congelados | positivos/negativos e diff | fixture não cobre o erro declarado. |
| P07 | revisão independente do candidato congelado | revisor independente | nenhuma | pacote `BASE..HEAD`, achados/reprodução | candidato móvel, evidência ausente ou P0/P1. |
| P08 | review-of-review e recomendação de decisão | root | somente artefato de revisão permitido | rerun focal + readback | tentativa de autoaceitar ou avançar sem autoridade. |
| P09 | aceite/rejeição explícita da emenda S1A | operador do projeto | nenhuma | decisão sobre candidato revisado | aceite inferido de documento, teste ou commit. |

P01–P04 são preparação. P05–P09 são a parte executável de S1A e permanecem
`not admitted`; não podem começar apenas porque o grafo existe.

## Dependências causais e waves

```text
P01 -> [P02, P03]
[P02, P03] -> P04 (freeze)
P04 -> P05 (admissão física)
P05 -> P06 -> P07 -> P08 -> P09
```

| Wave | Unidades | Paralelismo | Gate de saída |
| --- | --- | --- | --- |
| preparação | P01, P02, P03, P04 | P02/P03 podem ser independentes após P01 | emenda candidata, Test Design, DAG e denominador revisáveis. |
| execução S1A | P05, P06 | serial red→green; QA de P05 distinto do implementador de P06 | guardas focados e scope sem core/runtime. |
| revisão e decisão | P07, P08, P09 | serial | review independente, recomendação root e decisão do operador. |

As arestas são causais: P02/P03 definem os requisitos e oráculos que P04
congela; sem P04 não há write scope/admissão para P05; sem red válido P06 não
prova o guard; freeze precede a revisão independente P07. Nenhuma wave é
autorização de início.

## Gates

| Gate | Owner | Antes de | Prova exigida | Estado |
| --- | --- | --- | --- |
| G01 baseline | root | P02/P03 | branch, `HEAD`, status, diff e reabertura de locators | planejado. |
| G02 proveniência | root + pesquisa independente | P04 | tag/commit/licença OpenSpec, tree digest e limites do delta | satisfeito para S1A por receipt nesta geração; compatibilidade fica fora de S1A. |
| G03 Test Design | QA independente | P04 | R01/ACV1 e fixtures/oráculos completos | planejado, aguardando revisão root. |
| G04 freeze | root | P05 | denominator, DAG, write scopes, modelo/esforço, orçamento e rollback | pendente. |
| G05 Plane | root via MCP | P05 | unidade de execução criada/readback, sem encerrar CODEX-26 | pendente. |
| G06 dispatch | root | P05 | adapter suportado/callable; missão e escopo entregues | pendente. |
| G07 red válido | QA de P05, seguido pelo implementador P06 | P06 | primeiro teste falha pelo comportamento ausente, não infraestrutura | pendente. |
| G08 revisão | revisor + root | avanço posterior | candidato congelado, `BASE..HEAD`, comandos e resultado | pendente. |

## Contrato da futura unidade Plane e staffing

Antes de P05, criar ou reidratar uma **unidade de execução S1A** separada de
`CODEX-31` e de `CODEX-26`. Ela deve conter objetivo, paths, exclusões,
aceites, dependências, responsável, revisão, stop rules e validação. O título,
taxonomia, assignee, estado e payload são pendentes de descoberta/preflight;
este documento não os inventa.

O dispatch físico usa somente um adapter comprovadamente callable. P05 vai a
QA independente; P06 vai a implementador distinto (Terra/medium,
`fork_turns=none`, salvo receipt que determine outro); P07 vai a revisor
distinto (Terra/medium, `fork_turns=none`). O packet também fixa
`fork_turns=none` para a autoria QA de P05. Root retém integração e
review-of-review; o operador do projeto decide P09. Autor de fixture/teste não
aceita a própria cobertura.

## Escopo, TDD e rollback de P05/P06

Paths candidatos exclusivos:

- `tests/fixtures/contract-v1-authority/`;
- um teste focado novo de precedência/denominador sob `tests/`;
- documentação/addendum explicitamente aprovada em `planning/architecture/` e
  `planning/executive/`.

Proibidos: `core/contracts/v1/`, todo adapter ativo, `global-runtime/`,
user-home, `.accelerate/` de CODEX-26, install/CLI remoto e qualquer estado
Plane além da unidade S1A autorizada.

O Test Design define os cinco negativos: fonte externa priorizada, export
gerado como fonte, requisito ACV1 sem disposição, Wave 0/S1B sem predecessor e
S1B antes de emenda aceita. O red deve falhar por guard inexistente/incompleto;
falha de shell, import, permissão ou dependência é inválida.

Rollback de P05/P06: reverter somente o commit S1A identificado quando o diff
for restrito a estes paths. Se houver overlap, parar, preservar evidência e
usar worktree isolado sob novo plano. Não há rollback operacional porque S1A
não possui payload runtime.

## Critério para `TASKS_READY`

O grafo alcança `TASKS_READY` somente quando P01–P04 estão completos, o
denominador e as arestas foram validados, o Test Design foi revisado, G01–G04
passaram, e o escopo de P05/P06 está congelado. Isso ainda não admite execução.
G05 e G06 são necessários antes de qualquer mutação da parte executável. P09
é necessário para chamar S1A de aceito; Wave 0/S1B continuam bloqueadas até
essa decisão e seus próprios gates.

## Regra de reentrada

Mudar baseline, decisão ACV1, paths, OpenSpec, requisitos, Test Design,
denominador, adapter ou orçamento torna P01–P04 e seus pareceres afetados
stale. Reabrir a geração e congelar novo pacote; não reaproveitar a admissão.
