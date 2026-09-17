# Accelerate v0.2.0 — SDD consolidado do produto

## Estado e autoridade

- Estado deste artefato: `accepted` para **design-only**. Ele não autoriza
  implementação, instalação, promoção, cutover, mudança de runtime ou início
  de S1A.
- Modo de especificação: `hierarchical`. O trabalho define fronteiras entre
  core, adapters de workflow/runtime, contrato de evidência, avaliação e mais
  de um harness. Esse é o gatilho objetivo do modo hierárquico; não é um rótulo
  de complexidade ou uma licença para ampliar escopo.
- Issue canônica: `CODEX-31` — “Consolidar SDD e matriz de reconciliação”.
- Owner de planejamento: Codex root. Aceitador independente: a designar; o
  autor/root não pode ser o único aceitador.
- Baseline da fonte: branch `v0.2.0`, commit
  `7c2966c5b86ceba9e4217c17b8fbbd1a90248a2e`.
- Dependência externa fixa para o **novo produto**: OpenSpec `v1.12.0`, commit
  `e062b9572be933564ba3899d059377dfa1393e32`. A tag/commit é referência de
  proveniência, não uma instrução para instalar ou importar o CLI. A tag e o
  commit foram conferidos por `git ls-remote`; integridade de pacote/formato e
  compatibilidade seguem pendentes para o gate de S1A.
- `CODEX-31` é lifecycle externo, não uma alegação derivada do repositório. A
  última leitura governada desta rodada identificou o item
  `e31850d4-275d-4ef1-a078-50c79ea60020`; toda decisão lifecycle futura deve
  reler o provider.

Este SDD deriva da [discussion literal](2026-09-05-accelerate-consolidation-discussion-verbatim.md)
e das [decisões D01–D10](2026-09-05-accelerate-consolidation-decision-intake.md).
Esses registros continuam sendo evidência histórica da decisão. Este arquivo
é a autoridade de design do produto v0.2.0 somente no escopo aceito abaixo.

### Aceite de design

- Aceitador: operador do projeto.
- Data: 2026-09-05.
- Autoridade: instrução explícita “Aceito o SDD v0.2.0 somente como design”.
- Revisão independente prévia: `PASS`, sem findings P0–P3, sobre o candidato
  desta geração.
- Efeito: autoriza usar este SDD e sua matriz como direção de design; não
  autoriza S1A, Wave 0, escrita em `core/contracts/v1/`, dispatch físico,
  instalação OpenSpec, qualificação Hermes, avaliação paga ou encerramento de
  `CODEX-26`.
- Residual de lifecycle: o receipt Plane
  `997657c897c63c6042c3024b45d10377f13e028aecfc7728b0f11ff6e29f2bd1`
  permanece pendente de reconciliação de adapter. O comentário foi lido, o
  item permaneceu `In Progress`, mas o reconciliador v3 recusou-o por não ser
  um receipt `comment-pending`; nenhuma repetição/PATCH foi realizada. Isso
  não altera este aceite documental e não pode ser escondido como receipt
  reconciliado.

### Limite de autoridade

`AGENTS.md`, `SKILL.md`, os contratos ativos sob `core/` e as regras de
controle de mudança do repositório permanecem acima deste SDD. O SDD não torna
uma capability existente “aceita”, não fecha `CODEX-26` e não altera estados
de Plane. Quando uma fonte superior divergir, a divergência é bloqueante até
uma mudança normativa explícita e revisada; ela não é resolvida por texto
interpretativo neste documento.

## Problema a resolver

O Accelerate já contém mecanismos de hardening, roteamento proporcional,
delegação, revisão, waves, evidência, fechamento, avaliações de skills e um
spike Phase 1 de OpenSpec. Também há contratos e planos de Contract v1 que
descrevem evidência tipada, invalidação e fechamento transacional. Essas peças
não constituem, por si, uma autoridade executável única para a nova versão:

- o Contract v1 tem SDD e plano aceitos como design, mas o pacote canônico
  `core/contracts/v1/` e seu denominador de waves não estão materializados no
  baseline acima;
- `CODEX-26`/Phase 1 existe como implementação fixture/offline ligada a
  OpenSpec 1.11.0 e seu handoff histórico é `implementing-not-accepted`;
- a decisão nova fixa OpenSpec 1.12.0 para o produto novo, sem reescrever ou
  declarar equivalente a evidência 1.11.0;
- testes de scripts, schemas, fixtures e documentação podem demonstrar
  integridade estrutural, mas não demonstram que o Accelerate ou um harness
  resolveu problemas de engenharia;
- uma integração direta de OpenSpec ou Superpowers como autoridade concorrente
  criaria duas fontes de decisão, dois schedulers ou dois modelos de
  fechamento.

O Contract v1 não é descartado por esta discussion. `ACV1-A001`, seu SDD, as
seis waves e o catálogo de 45 tarefas permanecem a autoridade de design aceita
para qualquer escrita em `core/contracts/v1/`. Este SDD somente propõe uma
reconciliação/emenda: antes de tocar esse pacote, ela deve dispor cada requisito
ACV1 como mantido, alterado ou substituído e declarar a relação com Wave 0 e
suas saídas. Sem uma emenda aceita, não há autorização para Wave 0 nem para um
contrato paralelo.

O objetivo é transformar essas superfícies em um produto controlável e
avaliável: uma autoridade local, um modelo explícito de mudança de
especificação, rastreabilidade verificável, provas que envelhecem corretamente
e uma avaliação de comportamento separada de qualificação de provider.

## Objetivo e não objetivos

### Objetivo

Consolidar no Accelerate um control plane portátil e repo-owned que:

1. governe escopo, requisitos, mudança, tarefas, execução, revisão, evidência
   e fechamento;
2. use capacidades selecionadas de OpenSpec 1.12.0 e Superpowers apenas como
   mecanismos adaptados, versionados e avaliados localmente;
3. mantenha os modelos como instrumentos independentes de observação e não
   como “vencedores” do produto;
4. permita, em etapa posterior, qualificar o Hermes Agent como primeiro
   harness end-to-end sem transformar suposições Hermes em semântica portátil;
5. prove melhoria por cenários congelados e decisões de promoção/revisão/
   rejeição, em vez de por contagem de documentos ou testes verdes isolados.

### Não objetivos desta geração de design

- implementar código, criar `core/contracts/v1/`, instalar OpenSpec ou mudar
  loaders/adapters;
- alterar runtime, sessão, memória, permissões, ferramentas, credenciais,
  serviços ou o Hermes Agent;
- executar avaliações pagas, qualificar provider/modelo, promover um modelo ou
  alegar capacidade de resolução de problemas;
- substituir Plane por GitHub, ou tratar PR #9 como a autoridade de ciclo de
  vida;
- fechar, aceitar retrospectivamente ou migrar silenciosamente `CODEX-26`;
- importar o bootstrap, hooks, aprovação universal ou serialização obrigatória
  de implementadores do Superpowers.

## Decisões consolidadas

| Decisão | Disposição consolidada | Consequência verificável |
| --- | --- | --- |
| D01 | Um SDD novo e uma matriz de reconciliação são a futura autoridade de design. | Cada capacidade tem fonte, estado, disposição e destino local. |
| D02 | Avaliações usam baseline congelado, não um worktree implicitamente mutável. | Todo run registra commit, árvore/diff aplicável e exclusões. |
| D03 | Phase 1 é inventariado por requisito e prova, não por volume de arquivos. | Implementado, provado, aceito e runtime-qualified permanecem campos distintos. |
| D04 | OpenSpec 1.12.0 é a referência fixa do produto v0.2.0. | Qualquer uso registra tag, commit, origem, licença e delta contra 1.11.0. |
| D05 | TDD observável, qualidade de teste, BASE..HEAD e evals comportamentais são adaptados localmente. | Nenhum bootstrap externo passa a decidir a execução. |
| D06–D07 | Hermes é primeiro harness-alvo, com isolamento comprovado posteriormente. | Adapter Hermes mapeia semântica; não a redefine. |
| D08–D10 | Qualificação operacional, comportamento do Accelerate e resultados de engenharia são conjuntos separados. | Painel, rubrica, denominador, custo e promoção têm registros distintos. |

## Arquitetura-alvo

### Uma autoridade, três grafos relacionados

O erro a evitar é representar toda dependência como uma única lista de tasks.
Há três relações diferentes, com perguntas e regras de validade diferentes:

```text
spec vigente ── mudança proposta ── cenários ─────────────┐
       │              (grafo de artefatos)                │
       │                                                  ▼
requisito ── tarefa/wave ── tentativa ── revisão ── fechamento
            (grafo de execução)             │
                                               ▼
code/spec/env/review ── invalida ── evidência ── reproof
                       (grafo de validade)
```

| Grafo | Pergunta | Owner | Propriedade que não pode ser inferida |
| --- | --- | --- | --- |
| Artefatos/especificação | Qual artefato depende de qual definição e qual delta foi aceito? | gestão local de specs | arquivo existente não é spec válida nem aceita. |
| Tarefas/waves | Qual trabalho pode iniciar e quais escopos podem ser paralelos? | scheduler do Accelerate | tarefa `done` não é fechamento. |
| Evidência/invalidação | Que prova deixa de valer após mudar código, spec, ambiente ou tentativa? | Contract v1/local evidence core | teste verde anterior não é prova atual. |

Os grafos compartilham IDs, mas não seus estados. Uma spec pode estar pronta
para leitura enquanto a tarefa correspondente ainda não está aceita; uma tarefa
pode terminar enquanto a revisão ou prova se tornou stale.

### Camadas e fronteiras

| Camada | Responsabilidade | Não deve fazer |
| --- | --- | --- |
| Core portátil | modelos, schemas, invariantes, IDs, relação dos três grafos e validade de prova | chamar provider, conhecer caminhos Hermes ou decidir uma UI. |
| Gestão de especificação | spec vigente, change proposal, cenários, operações add/modify/remove/rename e reconciliação | marcar implementação aceita pela mera existência de arquivo. |
| Planejamento e scheduler | hardening, classificação, tasks, waves, ownership, escopos de escrita e gates | usar o grafo de spec como scheduler concorrente. |
| Evidência e fechamento | evidência tipada, invalidação, revisões, receipts, shadow close e decisão | substituir um runtime adapter ou inferir qualidade da revisão. |
| Adapters de runtime/workflow | converter primitives nativas em recibos e capacidades efetivas | infiltrar supostos provider/modelo no contrato portátil. |
| Eval Lab | comparar baseline/candidato e registrar decisão | se tornar autoridade de execução ou autopromover mudanças. |

### OpenSpec e Superpowers: disposição de integração

OpenSpec 1.12.0 informa a semântica de evolução de specs: spec vigente versus
mudança proposta, dependências de artefatos, cenários preservados e
reconciliação do delta aprovado. O formato interno será definido pelo contrato
local. Compatibilidade de importação/exportação só é adotada se entregar valor
provado; o CLI TypeScript, stores beta, estado baseado apenas em existência de
arquivo e qualquer segunda árvore manual de tasks não entram por padrão.

Superpowers informa disciplinas, não autoridade: red/green/refactor observável
quando aplicável, testes com oráculo independente, pacote de revisão do escopo
integral `BASE..HEAD` e cenários de pressão para skills. O pacote local deve
incluir requisito, cenário, restrições, mudanças, ambiente relevante,
resultados, evidências e findings. Um fallback `HEAD~1..HEAD` não pode ser o
único denominador de tarefa multicommit.

## Contrato de rastreabilidade

Todo item abaixo recebe identificador estável, revisão e relação explícita:

```text
requirement
  -> acceptance scenario
  -> spec/change revision
  -> task + wave + write scope
  -> execution attempt + candidate revision
  -> test/evidence record
  -> independent review + finding disposition
  -> validation receipt + closure decision
```

Uma evidência de teste precisa bindar sujeito/revisão de código e spec, comando,
ambiente relevante, resultado, digest de saída, tentativa e redaction. Uma
revisão precisa bindar intervalo real (`BASE..HEAD` ou equivalente), critérios
recebidos, candidato e findings. Um fechamento só pode consumir evidência
vigente e não bloqueante. Atualizar código, spec, ambiente material ou tentativa
aciona invalidação direcionada; não autoriza reaproveitar um recibo só porque o
comando tem o mesmo nome.

## Requisitos de produto e provas planejadas

| ID | Requisito | Prova mínima futura |
| --- | --- | --- |
| R01 | Há uma única fonte local de autoridade para classificação, execução, evidência e fechamento. | fixtures de precedência e revisão de conflitos. |
| R02 | Especificação vigente e mudança proposta são objetos distintos, com cenários preservados ao aplicar delta. | positivos/negativos de add/modify/remove/rename e perda de cenário. |
| R03 | Prontidão de artefato não equivale a validade, aceite, execução ou fechamento. | fixture que rejeita promoção por mera existência. |
| R04 | Tasks/waves preservam dependências, ownership e paralelismo somente em escopos de escrita disjuntos. | fixtures de conflito, ordem e root/child ownership. |
| R05 | Evidência é tipada, ligada à revisão e invalidada transitivamente quando apropriado. | testes de stale proof, revisão antiga e rerun seletivo. |
| R06 | Waiver, `done` e cobertura não podem contornar prova obrigatória, ID único ou autoridade. | fixtures para prova ausente, ID duplicado e waiver inválido. |
| R07 | O pacote de revisão cobre a tarefa inteira e sua aceitação, não só o último commit. | cenário multicommit com `BASE..HEAD` e finding reconstruível. |
| R08 | TDD é proporcional e observável; não se declara red/green por um teste quebrado por infraestrutura. | casos red válido, red inválido, caracterização e regressão. |
| R09 | Padrões são ligados ao mecanismo correto: check, teste, revisão ou eval. | matriz padrão→mecanismo e falsos positivos/negativos. |
| R10 | Modelos de avaliação são observadores independentes, com pacote congelado e pareceres isolados. | recibos de sessão/contexto/artefato e teste de sentinela. |
| R11 | Hermes é adapter/harness qualificado, não premissa do core. | contrato de capacidade e smoke por primitive efetiva. |
| R12 | Promoção exige gates não compensáveis e benefício medido contra baseline. | decisão reproduzível promote/revise/rerun/reject/pattern-only. |

## Avaliação: o produto sob teste é o Accelerate

O experimento não é uma competição de modelos. O objeto avaliado é a execução
do Accelerate: entendimento da missão, rota, seleção de modelo/esforço,
contexto, ações, evidência, independência, revisão, correção, resíduos e
fechamento. Os modelos são instrumentos independentes que observam o mesmo
pacote congelado.

```text
pacote de run congelado
  ├─ avaliador cego A ┐
  ├─ avaliador cego B ├─ pareceres anonimizados ─> julgador ─> consolidador
  └─ avaliador cego C ┘
```

O piloto posterior usa famílias diversas conforme disponibilidade qualificada,
com Sol como julgador e Astra como consolidador somente se o harness demonstrar
o isolamento necessário. Cada avaliador responde a uma rubrica fixa: missão,
rota, modelo/esforço, feito versus alegado, andamento, pendência, qualidade da
evidência, excesso/falta de processo, riscos, próximos passos e veredito.
Julgador e consolidador recebem múltiplos pareceres anonimizados, confrontam
alegações com a evidência original e citam a prova que sustenta cada conclusão.

São trilhas distintas:

1. qualificação operacional de provider/modelo/harness;
2. comportamento do Accelerate/agentes sob uma configuração congelada;
3. resultado de engenharia em tarefas reais.

Nenhuma microfixture existente, teste semântico de Markdown, health check,
commit ou resposta do gateway é evidência suficiente de capacidade de resolver
problemas. Essa afirmação permanece explicitamente fora do estado atual.

## Isolamento e Hermes Agent

Quando o slice de harness for autorizado, cada avaliador deverá ter sessão e
artefatos próprios, pacote-base read-only idêntico, nenhuma leitura de parecer
de pares, memória/contexto controlados, tools/permissões declarados e recibos
para fallback/erro. Workspaces de execução do candidato e de avaliação são
separados. Sentinelas não secretas devem provar ausência de compartilhamento
indevido. Cache de resposta e cache de prefixo são declarados separadamente;
limitação de observabilidade do provider é uma limitação, não uma alegação de
isolamento físico.

Se Hermes não puder provar essas propriedades, o resultado fica marcado como
`limited` ou `invalid-for-strict-independence`; Codex, API direta ou outro
harness não o substituem silenciosamente.

## Primeiro slice proposto — S1A, reconciliação de autoridade Contract v1

S1A vem antes de qualquer fundação de mudança de spec. Ele evita escrever
`core/contracts/v1/` com uma interpretação implícita de ACV1-A001. É uma
proposta de task graph e só entra em execução após aceite deste SDD, Test
Design, task graph congelado e dispatch físico conforme a política vigente.

| Aspecto | Definição de S1A |
| --- | --- |
| Objetivo | Produzir a emenda ACV1↔v0.2.0, o mapa requisito→disposição→wave e um denominador de conformance que determine se/como o futuro S1B poderá tocar `core/contracts/v1/`. |
| Escopo candidato | `planning/architecture/` para a emenda e mapa; `planning/executive/` para um addendum de dependências sem editar o plano histórico; `tests/fixtures/contract-v1-authority/` e um teste focado de precedência/denominador. Não há escopo em `core/contracts/v1/`. |
| Exclusões | nenhum adapter ativo, loader, user-home, CLI global, store remoto, Plane mutation adicional, Hermes, eval pago, mudança de scheduler, cutover ou escrita de contrato canônico. |
| Entrada | SDD aceito independentemente; matriz com locators revisados; proveniência 1.12.0 verificada; baseline e denominador do teste de autoridade congelados. |
| Saída | emenda que preserva/dispõe cada requisito ACV1, relação explícita com Wave 0, fixture que recusa autoridade concorrente e receipt de revisão/rollback. |
| Teste | TDD com fixtures: fonte externa priorizada, export gerado como fonte, requisito ACV1 sem disposição, wave iniciada sem predecessor e tentativa de S1B antes da emenda aceita. |
| Revisão | pacote contém requisito ACV1, disposição, `BASE..HEAD`, diff, fixtures, comandos/resultados e nenhum relato do implementador como prova única. |
| Rollback | reverter o commit S1A identificado no receipt, somente se o diff tocar apenas os paths S1A; se houver overlap, parar e reverter por commit em worktree isolado. S1A não toca core/runtime e não exige migração operacional. |

S1A não prova integração completa de OpenSpec, melhoria de resultado de
engenharia ou operação Hermes. Um futuro S1B de semântica de change/spec só
existe após S1A ser aceito e declarar corretamente seu vínculo com a Wave 0;
assim evita-se começar pelo adapter/CLI ou por um pacote paralelo antes de
haver autoridade local verificável.

## Disposições obrigatórias do Specification Lifecycle

| Superfície | Disposição | Razão e owner/locator |
| --- | --- | --- |
| ADR | consolidated | Owner: root; locator: este SDD, “Estado e autoridade” e “Arquitetura-alvo”. Registra autoridade única; ADR separado só é exigido se o aceite alterar norma superior. |
| Produto/UI | not-applicable | S1A não altera interface de produto, UX ou artefato visual; owner: root; locator: esta tabela. |
| Test Design | separate | Antes de S1A: `planning/architecture/<date>-accelerate-v020-s1a-test-design.md`, owner: test/QA independente, com denominador e oráculos para R01/ACV1. O desenho de avaliação R01–R12 é produto-wide e será um artefato separado posterior. |
| Contrato de agente/staffing | consolidated | Owner: root; locator: este SDD, “Avaliação” e “Isolamento”. Define papéis; profiles físicos e provider bindings ficam para o slice de harness. |
| Rollout | not-applicable | S1A é source-only, sem payload operacional; owner: root; locator: “Primeiro slice”. Um rollout separado é obrigatório antes de adapter/harness ativo. |
| Rollback | consolidated | Owner: root; locator: “Primeiro slice”. O receipt deve identificar o commit S1A e paths exclusivos; operação runtime requer runbook próprio. |
| Observabilidade | consolidated | Owner: root; locator: este SDD, “Contrato de rastreabilidade”. IDs, receipts, invalidação e run packets são daqui; telemetria Hermes é posterior. |
| AGENTS/docs | separate | Owner: mantenedor da norma alterada; locator futuro: proposta específica sob `planning/architecture/`. Qualquer mudança em `AGENTS.md`, root skill ou docs governantes não é efeito automático deste SDD. |

## Gates de entrada, aceitação e reentrada

### Antes de implementação

1. reconciliar toda linha da matriz com fonte e estado observável;
2. ter este SDD em `accepted` por revisor independente;
3. aceitar a emenda ACV1↔v0.2.0 e cumprir a entrada/saída de Wave 0 antes de
   qualquer escrita em `core/contracts/v1/`;
4. congelar S1A, requisitos, fixtures, ownership, write scopes, modelo/esforço,
   orçamento e provas planejadas;
5. verificar a proveniência OpenSpec 1.12.0 por tag/commit/integridade;
6. criar Test Design separado e fazer o primeiro teste falhar pelo motivo
   esperado;
7. abrir uma unidade de execução no Plane sem fechar `CODEX-26`;
8. dispatch físico somente por adapter suportado/callable, com root mantendo
   integração e review-of-review.

### Aceitação do SDD

O revisor independente deve verificar particularmente se (a) “aceito” não foi
inferido de “implementado”, (b) 1.11 e 1.12 estão separados, (c) existem dois
grafos ou autoridades concorrentes escondidas, (d) a avaliação não se vende
como benchmark de resolução de problema, e (e) S1 permanece pequeno e sem
efeito runtime e sem antecipar a Wave 0. O root só reconcilia a revisão; não
se autoaceita.

### Reentrada

Reabrir o design e incrementar a geração se uma descoberta mudar semântica,
proprietário, compatibilidade OpenSpec, capacidade Hermes, validade de prova,
isolamento, custo/limite, rollout/rollback ou o primeiro slice. Prova e
pareceres afetados tornam-se explicitamente stale; nenhuma decisão antiga é
reutilizada por conveniência.

## Riscos conhecidos e decisões pendentes

| Risco/decisão | Mitigação ou condição |
| --- | --- |
| Delta material OpenSpec 1.11 → 1.12 | S1A registra o gate de proveniência; S1B só começa com mapeamento de compatibilidade e fixtures, sem upgrade retrospectivo. |
| Evidência narrativa superar prova | links, digest, sujeito/revisão e validador determinístico são requisitos do receipt. |
| Processo excessivo em tarefa pequena | rota proporcional e cenário de manutenção simples são métricas do Eval Lab. |
| Isolamento de painel não demonstrável | marcar rodada limitada/inválida; não substituir por alegação de sessão. |
| Custo e repetição não definidos | D09 não inicia rodada paga sem teto de custo, tempo, tokens, timeout e retry aprovado. |
| Código Phase 1 confundido com produto v0.2.0 | matriz preserva limites e `CODEX-26` fica com lifecycle próprio. |
| Conflito documental de Superpowers | adaptar e registrar proveniência; não executar bootstrap externo como autoridade. |

## Próxima sequência

1. confirmar a [matriz de reconciliação](2026-09-05-accelerate-v020-reconciliation-matrix.md)
   contra o baseline e contra o readback de `CODEX-31`;
2. preparar a emenda ACV1↔v0.2.0, Test Design e task graph de S1A, ainda sem
   implementação;
3. obter revisão arquitetural independente e review-of-review root;
4. se aceito, abrir a primeira unidade de implementação sob o gate de
   delegação e as condições acima; se não aceito, revisar este SDD sem avançar.
