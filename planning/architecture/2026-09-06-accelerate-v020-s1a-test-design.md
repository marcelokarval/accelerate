# CODEX-31 — Test Design de S1A (R01/ACV1)

## Estado, limite e autoridades

**Estado:** `accepted`, estratégia pre-code de S1A aceita pelo root após revisão independente do candidato congelado em `d7f18a015d2f3bfe1fce4b8f7787e7d774c735bf`. Não é Wave Packet, não aceita a emenda S1A e não relata teste observado. O SDD v0.2.0 continua `design-only`; comandos e resultados deste documento permanecem futuros até P05.

**Denominador:** apenas R01 e reconciliação ACV1↔v0.2.0 de S1A. R02, R03 e R05 pertencem ao futuro S1B/produto e estão excluídos, conforme a matriz, “Mapa de requisitos para o primeiro slice”. Nada aqui autoriza `core/contracts/v1/`, adapter, runtime, OpenSpec, Plane, `.accelerate/` ou export global.

| Papel | Locator preciso | Uso |
| --- | --- | --- |
| Norma superior | `AGENTS.md`, “Self-Contained Authority”, “Standing Multi-Agent V2 Delegation Request”, “Workflow Backend Reality” | A fonte é repo-local; execução futura segue seus gates e não inventa backend remoto. |
| Design S1A | `planning/architecture/2026-09-05-accelerate-v020-consolidated-sdd.md`, “Estado e autoridade”, “Primeiro slice proposto — S1A”, “Gates de entrada, aceitação e reentrada” | Define R01, cinco negativos, escopo e primeiro red válido. |
| Reconciliação | `planning/architecture/2026-09-05-accelerate-v020-reconciliation-matrix.md`, “Denominador e fontes verificadas”, M03, “Mapa de requisitos para o primeiro slice” | Separa Contract v1 design-only, Phase 1 histórico e S1A de S1B. |
| ACV1 | `docs/architecture/accelerate-contract-v1-sdd.md`, “Authority And Source Of Truth”; `planning/executive/accelerate-contract-v1-master-plan.md`, “Plan Map And Dependencies”, “Global Entry Gate”, “Wave 0: Authority Graph” | Fixa precedência repo-local, export downstream e gates de predecessor. |
| Catálogo | `planning/executive/accelerate-contract-v1-task-catalog.md`, “Catalog Rules”, `ACV1-W0-001..006` | Conserva IDs/dependências; não cria catálogo paralelo. |

## Baseline e candidato a congelar

O baseline normativo é `v0.2.0` / `7c2966c5b86ceba9e4217c17b8fbbd1a90248a2e`, como registrado no SDD/matriz. O checkout de autoria estava em `v0.2.0` / `6d41fedc786f5216e7c6a488fc8de7c94c155738`; não é automaticamente candidato de S1A e não substitui o baseline normativo.

Não existe candidato de implementação S1A neste desenho. Antes de executar, o pacote de entrada aplicável deve registrar `BASE`, `HEAD`, árvore/diff, `git status --short --branch`, `git diff --name-only`, paths sujos, digest dos fixtures, denominador ACV1 e a emenda **candidata congelada e revisada**. O aceite da emenda não é precondição para executar a guarda S1A; ele é exigido para que Wave 0, S1B ou `core/contracts/v1/` avancem. Export, user-home, Phase 1/OpenSpec 1.11.0 e fontes externas nunca entram como fonte de verdade.

| Classe | Estado e path | Regra |
| --- | --- | --- |
| Emenda/mapa | **Materializado, candidato e não aceito:** `planning/architecture/2026-09-06-accelerate-v020-acv1-authority-amendment.md` | Cada requisito ACV1 recebe a disposição normativa `mantido`, `alterado` ou `substituído`, vínculo de Wave 0 e, quando necessário, observação de gate em campo separado. Artefato adicional só pode ser proposto posteriormente sob escopo explícito. |
| Task graph pré-entrada | **Materializado, candidato e não aceito:** `planning/executive/2026-09-06-accelerate-v020-s1a-pre-entry-task-graph.md` | Delimita a pré-entrada de S1A sem reescrever o plano histórico. Artefato adicional só pode ser proposto posteriormente sob escopo explícito. |
| Fixture | **Ainda não criado:** `tests/fixtures/contract-v1-authority/` | Esperados imutáveis: classes, precedência, disposições e guardas de autorização; não derivados do resolvedor. |
| Teste focal | **Ainda não criado:** `tests/accelerate-v020-s1a-authority.sh` | Exercita precedência/denominador e guarda R01 de S1A somente. |
| Implementação P06 | **Ainda não criado:** `scripts/validate-accelerate-v020-s1a-authority.py` | Validador determinístico de precedência repo-local e mapa ACV1↔v0.2.0. |

Excluídos: `core/contracts/v1/`, `global-runtime/accelerate/`, user-home, adapters ativos, loaders, CLI, stores remotos e estado `.accelerate/`.

## Estratégia e rastreabilidade

O menor nível eficaz é um teste local de contrato entre arquivos, determinístico e guiado por fixtures. A revisão documental independente é uma segunda camada: ela impede que a expectativa seja deduzida da implementação.

| Requisito / invariável | Unidade futura | Fixture e oráculo independentes | Green planejado |
| --- | --- | --- | --- |
| R01: única fonte local para classificação, execução, evidência e fechamento | Resolvedor S1A de precedência e leitor do mapa ACV1↔v0.2.0 | Fixture de seis classes: `governing-authority`, `supporting-reference`, `decision-artifact`, `backend-authority`, `generated-export`, `forbidden-authority`; esperado vem de `AGENTS.md` e do SDD Contract v1, “Authority And Source Of Truth”. | Escolhe somente fonte local permitida e registra classe/razão; reversão de precedência rejeita. |
| Todo requisito ACV1 tem disposição | Validador do mapa requisito→disposição→wave | Lista congelada de IDs do catálogo e tabela independente `ID -> disposição normativa -> nota de gate opcional -> wave`. A disposição aceita exclusivamente `mantido`, `alterado` ou `substituído`; uma observação de gate é campo separado e não altera `mantido`. | IDs completos e únicos, com disposição normativa válida, nota de gate separada quando houver, e vínculo explícito com Wave 0. |
| Drafts S1A não são autoridade de avanço | Guarda R01 que distingue emenda/task graph candidatos de uma autorização para Wave 0/S1B/core | Fixture com emenda candidata/revisada, emenda aceita, estado de Wave 0 e pedido de avanço, cada qual com revisão/digest. Não modela scheduler, paralelismo ou dependências gerais. | Um draft permite somente a avaliação S1A; Wave 0, S1B e `core/contracts/v1/` continuam bloqueados até a emenda aceita e os gates normativos correspondentes. |
| Export é downstream | Verificador fonte→export | Fixture da regra “Generated export rule” do SDD Contract v1 e “Authority And Generation Invariants” do master plan. | Export pode ter paridade, mas não resolve conflito nem fornece o esperado. |

## Red-first e negativos determinísticos planejados

O primeiro red será executado somente após fixture/candidato congelados e antes da correção S1A. É red válido apenas se falhar por ausência/não-conformidade S1A com marcador estável; shell, rede, dependência, permissão ou fixture ilegível significam `blocked`, não red. Este documento não alega que qualquer red ocorreu.

| ID | Entrada futura | Oráculo / red esperado | Efeito proibido |
| --- | --- | --- | --- |
| RED-S1A-00 | Teste focal contra baseline/candidato sem correção S1A. | Rejeita artefato/regra ausente ou não conforme; rótulo exato é congelado no fixture antes da implementação. | Declarar TDD, green ou aceite a partir de falha de infraestrutura. |
| NEG-R01-01 | Fonte externa tenta vencer autoridade repo-local em decisão R01. | Rejeita precedência externa; externa é apenas `supporting`/comparativa. | Usá-la para classificação, execução, evidência ou fechamento. |
| NEG-R01-02 | `global-runtime/accelerate/`/export gerado é apresentado como fonte canônica. | Rejeita borda reversa export→fonte; paridade não muda autoridade. | Derivar esperado do export ou aceitá-lo como autor. |
| NEG-ACV1-03 | ID ACV1 ausente do mapa, sem disposição normativa, ou com nota de gate usada como se fosse disposição. | Rejeita completude/estado e identifica ID, disposição inválida ou mistura de campos. | Iniciar Wave 0 ou preservar requisito implicitamente. |
| NEG-SEQ-04 | Um draft S1A tenta autorizar Wave 0, ou S1B tenta avançar sem o estado normativo anterior requerido. | Rejeita o draft como autoridade insuficiente e identifica emenda/gate/receipt faltante; não valida um scheduler ou grafo R04 genérico. | Pular gate de Wave 0 ou materializar `core/contracts/v1/`. |
| NEG-SEQ-05 | S1B é preparado/iniciado antes de emenda ACV1↔v0.2.0 aceita. | Rejeita emenda não aceita, mesmo com planning, fixture ou export existente. | Inferir aceite pela existência de documento, teste ou commit. |

Em green futuro, o revisor deve confirmar que o oráculo segue fora da unidade testada, que os cinco negativos voltam a falhar quando reintroduzidos e que `BASE..HEAD` só contém paths S1A congelados. `bash tests/all.sh` será regressão complementar, jamais substituto dos focais.

## Comandos e evidência planejados

Não executados neste Test Design; alguns só existirão após task graph/implementação autorizados:

```bash
git status --short --branch
git diff --name-only
bash tests/accelerate-v020-s1a-authority.sh --red-first
bash tests/accelerate-v020-s1a-authority.sh
bash tests/authority-set-gate.sh
bash tests/doctrine-integrity.sh
bash tests/markdown-link-integrity.sh
bash tests/all.sh
git diff --check
```

O receipt futuro preserva comando, exit code, marcador esperado, IDs/digest dos fixtures, `BASE..HEAD`, commit/árvore, inventário antes/depois e estado `planned`, `observed-red`, `green` ou `blocked`. Resultado do implementador nunca é prova única.

## Dimensões

| Dimensão | Disposição | Razão |
| --- | --- | --- |
| Happy / contrato | requerida | Mapa completo e precedência local correta provam R01. |
| Negativa / segurança de autoridade | requerida | Cinco negativos impedem autoridade concorrente, omissão e avanço indevido. |
| Limite / completude | requerida | IDs duplicados, ausentes ou com disposição inválida falham. |
| Ownership | requerida | Fonte, autor de fixture, implementador, revisor e root são distintos. |
| Concorrência / idempotência | not-applicable | S1A não cria scheduler, fila, estado transacional ou writes paralelos; reabrir se mudar. |
| Falha / recuperação / rollback | requerida | Falha bloqueia S1B; reversão é por commit S1A limitado e receipt preservado. |
| Observabilidade | requerida | Digest, revisão, marcador e inventário vinculam veredito ao candidato. |
| Browser/UI/acessibilidade/responsividade | not-applicable | Não há DOM, interface ou artefato visual. |
| Performance/carga/localização | not-applicable | Contrato local determinístico, sem SLA ou texto de produto. |
| Provider/rede/banco/instalação OpenSpec | not-applicable | Não existe integração nem chamada externa em S1A. |

## Independência, stop e rollback

- QA independente cria fixture/oráculo e o teste red, e não implementa nem aceita S1A. Implementador distinto executa a guarda P06/correção somente no escopo congelado, com `fork_turns=none`. Revisor independente posterior, fresco e read-only, usa `fork_turns=none` e compara candidate, emenda, mapa, fixtures, `BASE..HEAD` e receipts às autoridades acima. Root faz review-of-review, sem autoaceite.
- Parar como `blocked` se: emenda candidata não estiver congelada e revisada; baseline/candidato ou digest não fixado; conflito de locator; red de infraestrutura; path sujo sobreposto sem owner; toque em `core/contracts/v1/`, runtime/export/user-home; ou gate/receipt exigido para um avanço de Wave 0/S1B estiver ausente. Não há fallback interpretativo.
- Rollback futuro: reverter somente o commit S1A do receipt se o diff for exclusivo dos paths S1A. Havendo overlap, parar e reverter por commit em worktree isolado; preservar fixtures, receipts e revisão. Nunca usar reset, clean ou checkout destrutivo.

## Bloqueios futuros

1. Este Test Design e o task graph estão aceitos somente para entrada; não aceitam a emenda, não provam RED/GREEN e não substituem P07–P09.
2. A emenda ACV1↔v0.2.0 deve estar aceita e vinculada verificavelmente à Wave 0 antes de S1B.
3. Integridade/formato/compatibilidade de OpenSpec 1.12.0 seguem pendentes no gate próprio e não podem entrar como autoridade R01.
4. A unidade Plane `CODEX-34` foi criada em `Todo` e lida de volta; START, autoria independente P05, implementação P06, revisão P07 e aceite P09 seguem futuros. Este arquivo não fecha CODEX-31.
