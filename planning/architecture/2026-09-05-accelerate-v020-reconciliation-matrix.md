# Accelerate v0.2.0 — matriz de reconciliação

## Status, método e legenda

Estado: `draft`, ligado ao SDD consolidado de v0.2.0 e ao issue `CODEX-31`.
Esta matriz não muda autoridade nem aceita artefatos; ela torna as disposições
revisáveis antes de qualquer task de implementação.

Os termos abaixo são campos independentes, não uma escala que permita pular
etapas:

| Termo | Significado nesta matriz |
| --- | --- |
| existente | a fonte/artefato é observável no baseline. |
| implementado | há código ou mecanismo correspondente no baseline. |
| provado | há prova identificável para um comportamento delimitado. |
| aceito | um acceptor independente registrou aceite para o escopo exato. |
| qualified-runtime | adapter/harness demonstrou operação efetiva no runtime alvo. |
| parcial | uma parte é útil, mas faltam limites, requisitos, prova ou integração. |
| mantido | permanece como mecanismo local sob a nova autoridade. |
| implementado-equivalente | satisfaz a intenção de uma capacidade após validação de equivalência. |
| substituído | é preservado como histórico, mas outra superfície local passa a ser a execução futura. |
| conflitante | não pode coexistir como autoridade executável até decisão explícita. |
| novo | precisa de design/implementação nova; não inferir cobertura do material existente. |

`existente` ou `implementado` nunca implica `provado`, `aceito` ou
`qualified-runtime`. “Prova” também precisa carregar seu limite: fixture,
offline, semântico, integração, provider ou runtime.

## Denominador e fontes verificadas

| Item | Valor congelado para esta reconciliação |
| --- | --- |
| Candidate source | `v0.2.0` / `7c2966c5b86ceba9e4217c17b8fbbd1a90248a2e` |
| Produto novo OpenSpec | tag `v1.12.0`, commit `e062b9572be933564ba3899d059377dfa1393e32` |
| Phase 1 histórico | `CODEX-26`, SDD Phase 1, OpenSpec `v1.11.0` / `a0ddb60d040c61f4907436a9d91310934b1dda63` em receipt histórico |
| Contract v1 | `docs/architecture/accelerate-contract-v1-sdd.md` e plano de seis waves/45 tasks |
| Discussion | registro literal e decisões D01–D10 de 2026-09-05 |
| Work-item novo | Plane `CODEX-31`; Plane é lifecycle authority; PR #9 é somente draft GitHub da branch v0.2.0 |

As linhas afirmam somente o que foi observado nestas fontes. O ledger abaixo
fornece os locators do denominador. Uma revisão independente deve reabrir cada
locator, confirmar ou contradizer a linha e registrar qualquer novo fato com
commit, caminho, comando/recibo e revisão exatos. Linhas `parcial`,
`conflitante` ou `novo` são bloqueios explícitos, não lacunas esquecidas.

## Matriz principal

| ID | Capacidade / fonte observada | Estado factual no baseline | Disposição v0.2.0 | Destino e condição de avanço |
| --- | --- | --- | --- | --- |
| M01 | Root repo-owned, hardening, classificação e rotas proporcionais (`AGENTS.md`, `SKILL.md`, core) | existente; autoridade vigente | mantido | Continua como control plane; conflitos com novo SDD exigem alteração normativa separada. |
| M02 | Plane como tracker/lifecycle authority | existente e operacionalmente governado nesta fatia | mantido | CODEX-31 rastreia design; GitHub permanece superfície de código/review, não issue authority. |
| M03 | Contract v1: SDD, seis waves, 45 tasks, evidência tipada/invalidação/close transacional | design aceito em fontes; `core/contracts/v1/` e denominador canônico ausentes no baseline | mantido como design, bloqueado para escrita | `ACV1-A001`, seis waves e 45 tasks não são superados por este documento. Emenda aceita deve mapear cada requisito e cumprir Wave 0 antes de escrever `core/contracts/v1/`. |
| M04 | Phase 1 / `CODEX-26`: `core/phase1`, `adapters/openspec`, schemas e receipts | código e receipts fixture/offline existentes; handoff histórico `implementing-not-accepted` | parcial | Preservar e inventariar requisito/prova/aceite; não encerrar nem usar como aprovação v0.2.0. |
| M05 | Proveniência Phase 1 de OpenSpec 1.11.0 | receipt observável em `planning/openspec/evidence/release-receipt.json` | mantido-histórico | Continua a explicar Phase 1; não é upgrade nem compatibilidade automática para 1.12.0. |
| M06 | OpenSpec 1.12.0: specs vigentes, changes, cenários, deltas e grafo de artefatos | referência upstream fixa; não instalada/integrada no baseline | novo | Adotar semântica selecionada em contrato local; verificar licença, formato e delta antes de S1. |
| M07 | Detecção de artefato por existência no OpenSpec | comportamento upstream a avaliar, não autoridade local | conflitante | Accelerate deve manter existência, validade, aceite, execução e fechamento como estados distintos. |
| M08 | Grafo de dependência de artefatos | não há representação v0.2.0 canônica confirmada | novo | S1: modelo local para spec/change/cenário, ligado mas separado do scheduler. |
| M09 | Dependências de tasks/waves, ownership e gates | mecanismos/documentos locais existentes; validade completa ainda a reconciliar | mantido + parcial | Preservar scheduler; exigir IDs únicos, proof/waiver/denominador verificáveis antes de usá-lo como gate. |
| M10 | `wave_gate_report.py` e cálculos de cobertura | helper isolado tem limites já identificados; não é prova de bypass de fechamento completo | parcial | Não tratá-lo como certificador autossuficiente; criar fixtures para proof ausente, duplicata e waiver inválido. |
| M11 | Evidência tipada, invalidação e fechamento transacional | projetados pelo Contract v1; pacote canônico ausente | novo + parcial | Implementar somente após S1 e Test Design; receipts existentes não se convertem automaticamente. |
| M12 | Revisions, requested-vs-implemented e review-of-review | superfícies locais existentes | mantido | Melhorar pacote de revisão, preservando independência e root review-of-review. |
| M13 | Fallback de revisão `HEAD~1..HEAD` | observado na skill local; pode omitir parte de tarefa multicommit | substituído | Pacote local futuro usa BASE registrado antes da task até HEAD, mais requisitos/evidências/findings. |
| M14 | TDD e orientação de testes locais | material existente, sem skill universal localizada como autoridade | parcial | Adaptar TDD proporcional, red válido, teste de caracterização e oráculo independente. |
| M15 | Disciplina Superpowers de red/green/refactor e qualidade de teste | fonte externa de referência; não authority local | novo-adaptado | Traduzir para skills/profiles locais somente quando teste comportamental demonstrar benefício. |
| M16 | Bootstrap, aprovação universal e serialização obrigatória Superpowers | conflitam com rotas proporcionais, autorização já dada e waves paralelas | conflitante / excluído | Não importar. Preservar paralelismo só quando escopos são independentes e reconciliáveis. |
| M17 | Skill Evaluation Lab | workflow local observável | mantido | É a casa de baseline/candidato, blind comparison, custo e decisão; não autopromove mudanças. |
| M18 | Testes de integridade documental, como `one-shot-protocol-semantic.sh` | prova estrutural de âncoras textuais | mantido com limite | Rotular como estrutural; não afirmar que agente cumpriu protocolo. |
| M19 | Fixtures/validador de delegação e recibos de dispatch | existentes para invariantes declarados | mantido com limite | Reforçar com provas runtime/behavioral antes de alegar execução real/competência de revisão. |
| M20 | Runtime adapters e adapters workflow | arquitetura local prevista; remote workflow completo não confirmado | parcial | Contrato portátil primeiro; cada adapter declara primitive, estado, capability e receipt efetivos. |
| M21 | Hermes Agent | primeiro harness aprovado em direção, capacidade efetiva ainda não certificada | novo | Qualificar bootstrap, tools, sessões, persistência, cancelamento, resultado e fallback antes de panel. |
| M22 | Isolamento de avaliadores | requisito aprovado; não há prova de isolamento estrito no baseline | novo | Sessões/workspaces/pareceres separados, sentinelas e recibos; falha produz `limited`/`invalid`. |
| M23 | Modelo/provider qualification | matriz OmniRoute e material de capacidade são insumos, não teste do produto | mantido separado | Manter rows por ID/provider/route e não usar health como prova downstream. |
| M24 | Avaliação cega multi-modelo, Sol julgador e Astra consolidador | desenho aprovado; não executado | novo | Implementar após harness/isolation preflight, rubrica e orçamento aprovados. |
| M25 | Capacidade de resolução de problemas | não há benchmark real executado neste denominador | não-alegar | Somente cenário de engenharia pareado e prova externa permitem alegação limitada futura. |
| M26 | Padrões de arquitetura/domínio | instruções locais e perfis são inputs de prompt em vários casos | parcial | Mapear cada padrão para check determinístico, teste, revisão ou eval; prompt não basta. |
| M27 | Proveniência/upstream maintenance | campos e referências pontuais existem | parcial | Toda adaptação registra owner, upstream/commit, caminho, licença, delta local e estratégia de atualização. |
| M28 | GitHub v0.1.0 / v0.2.0, tag e PR #9 | release e branch foram preservadas anteriormente | mantido com limite | Não fazer merge/release/fechamento de PR como efeito do design. Mudanças futuras entram em commits/PR conforme ciclo aprovado. |

## Ledger de locators da matriz

| Linhas | Fonte primária no baseline | Limite que a fonte sustenta |
| --- | --- | --- |
| M01, M09, M12, M19, M20, M26 | `AGENTS.md`; `SKILL.md`; `core/control-plane/`; `core/review/`; `core/runtime-packets/` | existência de mecanismos/regras, não competência runtime. |
| M02 | Plane `CODEX-31` / id `e31850d4-275d-4ef1-a078-50c79ea60020`, re-leitura governada obrigatória | lifecycle externo desta discussion; não é prova armazenada no repositório. |
| M03, M11 | `docs/architecture/accelerate-contract-v1-sdd.md` §§ “Document Status”, “Machine Contracts”, “Acceptance Criteria”; `planning/executive/accelerate-contract-v1-master-plan.md` §§ “Plan Map”, “Global Entry Gate” | contrato/plano aceitos como design e suas precondições; ausência do pacote foi verificada no tree do baseline. |
| M04, M05 | `planning/architecture/2026-09-01-codex-26-phase1-openspec-core-sdd.md`; `core/phase1/`; `adapters/openspec/`; `planning/openspec/evidence/release-receipt.json` | implementação fixture/offline e proveniência 1.11, não aceite ou runtime. |
| M06–M08 | D04 no `2026-09-05-accelerate-consolidation-decision-intake.md`; tag/commit OpenSpec 1.12.0; fontes upstream a revalidar em S1B | direção e referência de proveniência; não integração instalada. |
| M10 | `global-runtime/accelerate/scripts/wave_gate_report.py` e cenário reproduzido na discussion literal | limite de helper isolado, não bypass de fechamento completo. |
| M13–M16 | `skills/review/requesting-code-review/SKILL.md`; D05 no decision intake; fontes Superpowers fixadas pela discussion | fallback local e disposição de adaptação; não importação de runtime. |
| M17–M18 | `core/workflows/skill-evaluation-lab.md`; `tests/one-shot-protocol-semantic.sh` | processo de avaliação e prova documental estrutural. |
| M21–M22 | D06–D07 no decision intake; `core/control-plane/cross-runtime-bootstrap.md` | intenção/contrato futuro; nenhum isolamento ou adapter Hermes qualificado. |
| M23–M25 | D08–D10 no decision intake; matriz OmniRoute é insumo externo separado | desenho de métricas/limites; nenhum benchmark de resolução de problema executado. |
| M27 | campos de proveniência referenciados por `AGENTS.md`; D05 e discussion literal | obrigação de origem/delta local; cobertura completa ainda requer inventário. |
| M28 | `git log --decorate` do baseline; branch `v0.2.0`; PR #9 a revalidar no GitHub quando uma operação GitHub for solicitada | estado de fonte local; não lifecycle authority. |

## Conflitos que exigem decisão explícita antes de código

| Conflito | Resolução proposta | Gate |
| --- | --- | --- |
| Contract v1 descreve pacote v1; Phase 1 já possui contratos próprios | Contract v1 continua autoridade de design aceita; Phase 1 permanece fixture/histórico até mapeamento requisito a requisito. S1A cria a emenda e a relação com Wave 0, sem escrever o pacote. | emenda ACV1↔v0.2.0 aceita + saída Wave 0. |
| OpenSpec pode tratar arquivo presente como conclusão; Accelerate exige provas/aceite | Separar `artifact_present`, `artifact_valid`, `artifact_accepted`, `execution_complete`, `evidence_current`, `closure_allowed`. | schema + negativos S1. |
| Superpowers fornece sequência serial; Accelerate suporta waves | Reusar pacote/disciplinas, não scheduler externo; paralelismo requer write scopes disjuntos e recibos. | task graph + fixture concorrente. |
| Provider/harness model ID versus capacidade real | Não inferir chamada/downstream por config/health; bindar request, adapter receipt e observação. | qualificação operacional independente. |
| Teste verde estrutural versus comportamento de agente | Manter ambos, identificando tipo/prova; behavioral eval é requisito separado. | Eval Lab e rubrica congelada. |

## Relação fase/estado — impedimentos de alegação

| Afirmação | Pode ser dita agora? | Razão |
| --- | --- | --- |
| “Há artefatos Phase 1 no baseline.” | Sim. | Código, adapter e receipts foram observados. |
| “Phase 1 está aceito/encerrado.” | Não. | Handoff histórico é `implementing-not-accepted`; CODEX-26 não foi alterado. |
| “Contract v1 está implementado.” | Não. | SDD/plano existem, mas pacote canônico esperado não está no baseline. |
| “OpenSpec 1.12.0 é a versão de referência do novo produto.” | Sim. | D04 aprovada e tag/commit fixados. |
| “OpenSpec 1.12.0 está integrado.” | Não. | Esta matriz não instala nem implementa integração. |
| “Os testes atuais comprovam resolução de problemas.” | Não. | Há tests/fixtures estruturais, não benchmark de engenharia/harness. |
| “Hermes garante isolamento cego.” | Não. | Ainda falta qualificação e sentinelas. |
| “A arquitetura v0.2.0 está aceita.” | Não. | SDD/matriz são drafts até revisão independente. |

## Mapa de requisitos para o primeiro slice

S1A cobre **somente R01/ACV1**. R02, R03 e R05 são preparação explícita para
S1B/produto e não pertencem ao seu Test Design nem ao seu denominador. O
denominador de S1A será congelado em Test Design separado; a lista abaixo é
intenção de sequência, não autorização de tarefa.

| Fase candidata | Requisito | Cenário negativo indispensável | Prova planejada |
| --- | --- | --- |
| S1A | R01 — autoridade única | entrada tenta dar prioridade a fonte externa ou export gerado | fixture de resolução e revisão de precedência. |
| S1B/produto futuro | R02 — vigente versus proposta | `modify` remove cenário existente sem disposição explícita | fixture de aplicação/rejeição de delta. |
| S1B/produto futuro | R03 — estados distintos | arquivo existe, mas schema/digest/revisão não são válidos | fixture rejeita prontidão/aceite/fechamento indevidos. |
| S1B/produto futuro | R05 — validade | spec vinculada muda após uma prova | fixture marca evidencia stale e exige rerun seletivo. |

## Próximas ações da reconciliação

1. reabrir em revisão independente cada fonte da coluna “estado factual”;
2. complementar esta matriz somente com observações ligadas a commit/caminho e
   prova delimitada;
3. criar a emenda ACV1↔v0.2.0 e Test Design de S1A, congelar fixtures e task
   graph;
4. aceitar ou devolver o SDD/matriz; nenhum código é iniciado enquanto o estado
   de design for `draft`.
