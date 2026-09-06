# Accelerate v0.2.0 — candidata à emenda de autoridade ACV1

## Estado, propósito e limite

Estado: `draft-pre-s1a`. Este é o candidato que S1A deverá submeter à revisão
independente e ao aceite apropriado. Não é um aceite, não inicia S1A, não abre
Wave 0 e não autoriza escrita em `core/contracts/v1/`.

Objetivo: registrar uma relação explícita e não concorrente entre `ACV1-A001`
(incluindo `ACV1-D001` a `ACV1-D024`) e o design aceito do produto v0.2.0. A
emenda impede que uma capacidade nova de v0.2.0 seja interpretada como
substituição implícita do Contract v1 ou que o Contract v1 seja interpretado
como autorização implícita para uma integração externa.

Autoridades, em ordem:

1. `AGENTS.md`, `SKILL.md` e owners nativos sob `core/`;
2. Contract v1: SDD, review index, master plan, seis waves e catálogo de 45
   tarefas;
3. SDD v0.2.0 aceito somente como design e sua matriz de reconciliação;
4. esta emenda candidata, limitada à preparação de S1A;
5. fontes externas, incluindo OpenSpec, somente como proveniência/informação.

O baseline factual do design é
`7c2966c5b86ceba9e4217c17b8fbbd1a90248a2e`. O candidato de planejamento
atual é a branch `v0.2.0` em `6d41fedc786f5216e7c6a488fc8de7c94c155738`
antes desta geração de artefatos. Esses identificadores não são recibos de
execução nem substituem a leitura de worktree na admissão futura.

## Decisão de reconciliação

`ACV1-A001` continua sendo o aceite histórico de design do Contract v1. Seus
IDs, decisões, seis waves e denominador de 45 tarefas são preservados. O
produto v0.2.0 acrescenta uma camada de decisão de design, não um novo
contrato canônico nem um segundo scheduler.

S1A é um slice de reconciliação de autoridade antes de Wave 0. Ele produz:

- esta emenda aceita ou rejeitada;
- um mapa ACV1 -> disposição -> Wave/S1A;
- um denominador de conformance que rejeita precedência externa, export
  gerado como autoridade, requisito ACV1 sem disposição e início indevido de
  Wave 0/S1B;
- um addendum que preserva o plano histórico e declara os novos gates.

S1A não produz `core/contracts/v1/`, não executa uma tarefa ACV1-W0, não
declara Wave 0 completa, não altera o catálogo e não integra OpenSpec. A
aceitação desta emenda será pré-condição para executar Wave 0/S1B e para
qualquer futura escrita canônica; não é pré-condição para redigir, revisar ou
congelar o próprio planejamento S1A.

## Proveniência externa delimitada

OpenSpec é referência para o novo produto, não autoridade de execução:

| Campo | Receipt de proveniência, fonte primária |
| --- | --- |
| Upstream | `Fission-AI/OpenSpec` |
| Tag fixa | `v1.12.0` |
| Commit | `e062b9572be933564ba3899d059377dfa1393e32` |
| Data/mensagem | 2026-09-03, `Version Packages (#1766)` |
| Pacote/licença | `@fission-ai/openspec`, MIT (`LICENSE`) |
| Evidência de identidade | `git ls-remote --tags ... refs/tags/v1.12.0` e checkout read-only do commit |

Receipt reconstruível desta geração: observado em 2026-09-06 pelo root e por
pesquisa independente; `git ls-remote --tags https://github.com/Fission-AI/OpenSpec.git
refs/tags/v1.12.0` devolveu exatamente o commit fixado. Um fetch raso desse
commit confirmou `package.json` (`@fission-ai/openspec`, `1.12.0`, `MIT`),
`LICENSE` (MIT) e árvore `10f256265a7f55ba0a0d92a6fc9a6171685579ac`.
O changelog do mesmo commit documenta `validate --report findings` e os demais
deltas abaixo. Este receipt prova identidade, origem e licença; não prova
integridade de pacote distribuído, compatibilidade, instalação ou runtime.

As fontes upstream relevantes para futura semântica são `src/core/validation/validator.ts`,
`src/core/archive.ts`, `src/core/schemas/{base,change,spec}.schema.ts`,
`src/core/parsers/change-parser.ts` e os templates de workflow. Nenhuma delas
altera a precedência acima. O delta 1.11 -> 1.12 (incluindo `validate --report
findings`, conflitos de merge e templates) é entrada de compatibilidade de
S1B; não foi analisado como equivalência nem instalado nesta etapa.

## Mapa completo de ACV1

`mantido` significa que a decisão continua válida. `guardado por S1A` significa
que S1A só torna sua precedência e bloqueio verificáveis; não a implementa.
`futuro` aponta a onda histórica que continua dona da implementação.

| Decisão | Disposição v0.2.0 | Dono de implementação | Condição/verificação de S1A |
| --- | --- | --- | --- |
| D001 autoridade repo-first | mantido | Wave 0 | S1A guarda a precedência: fixture rejeita fonte externa/export como autoridade. |
| D002 classes/modos fechados | mantido | Wave 1 | mapa declara sem mudança de vocabulário. |
| D003 schemas estritos | mantido | Wave 1 | nenhum schema paralelo é criado. |
| D004 validador Draft 2020-12 | mantido | Wave 1 | escolha concreta segue pendente; S1A não introduz dependência. |
| D005 catálogo + manifesto em paridade | mantido | Wave 0 | S1A tem denominator próprio sem editar os 45 IDs. |
| D006 cobertura P0/threshold | mantido | Wave 0 e posteriores | critérios não são relaxados. |
| D007 histórico de rollback append-only | mantido | Wave 3 | S1A tem rollback apenas por commit isolado. |
| D008 gates adaptativos monotônicos | mantido | Wave 2 | nenhum gate é dispensado por texto. |
| D009 evidência tipada | mantido | Wave 3 | planejamento separa prova planejada de observada. |
| D010 invalidação transitiva | mantido | Wave 3 | revisão/material change torna proof planejada stale. |
| D011 pós-merge condicionado | mantido | Wave 3 | não aplicável a docs pré-S1A sem merge claim. |
| D012 workers tardios | mantido | Wave 3 | não aplicável; não há worker de execução. |
| D013 cleanup tipado | mantido | Wave 3 | não aplicável; não cria recurso gerenciado. |
| D014 loop de incidente | mantido | Wave 3 | não aplicável; não corrige incidente. |
| D015 export repo -> runtime | mantido | Wave 5 | export/runtime é exclusão explícita. |
| D016 migração dry-run-first | mantido | Wave 5 | não há migração nem dual-write. |
| D017 validação final forense | mantido | Wave 5 | S1A prevê revisão, não fechamento. |
| D018 pacote canônico `core/contracts/v1/` | mantido | Wave 1 após Wave 0 | fixture recusa pacote concorrente/antecipado. |
| D019 mapeamento de labels legado | mantido | Wave 4 | nenhuma label é tratada como enum canônico. |
| D020 evento material pós-close | mantido | Wave 3 | não aplicável; não existe fechamento. |
| D021 cutover somente Wave 5 | mantido | Wave 5 | shadow/runtime são exclusões explícitas. |
| D022 fechamento lógico preparado | mantido | Wave 3/5 | não aplicável; sem lifecycle local novo. |
| D023 ferramenta forense é da Wave 4 | mantido | Wave 4 | revisores apenas usam provas futuras. |
| D024 export/rollback com intent/anchor | mantido | Wave 5 | não aplicável; sem export, host ou rollback operacional. |

## Relação com requisitos v0.2.0 e waves

| Requisito/escopo | Unidade de reconciliação | Saída que pode ser aceita | Não implica |
| --- | --- | --- | --- |
| R01 — autoridade única | S1A | mapa total ACV1 e precedência testável | Wave 0 concluída ou contrato implementado. |
| ACV1 D001, D005, D018 | S1A -> Wave 0 -> Wave 1 | guardas de entrada e vínculo causal | criação de graph/manifest/pacote. |
| R02/R03/R05; OpenSpec changes/specs | S1B posterior | design/compatibilidade separado | equivalência 1.11/1.12 por esta emenda. |
| R04/R06–R12 | slices posteriores | planos/provas próprios | cobertura por fixture S1A. |

O predecessor correto para escrita em `core/contracts/v1/` é:

```text
SDD v0.2 aceito
  -> S1A aceito (emenda + Test Design + denominator + revisão)
  -> Wave 0 admitida e aceita
  -> Wave 1 admitida
  -> core/contracts/v1 observation-only
```

`S1B` de change/spec também requer S1A aceito e seu próprio Test Design,
compatibilidade OpenSpec e unidade Plane. Ele não é um atalho para Wave 1.

## Critérios de aceite desta emenda

Para mudar o estado deste arquivo a `accepted`, um revisor independente deve
confirmar todos os itens:

1. os 24 IDs ACV1 têm uma única disposição e um owner/wave coerente;
2. nenhuma disposição altera silenciosamente `ACV1-A001`, os 45 IDs ou os
   caminhos canônicos das waves;
3. o Test Design S1A cobre R01/D001/D005/D018 com oráculos independentes;
4. o grafo S1A tem denominador congelado, escopos de escrita e gate de
   admissão; e
5. a proveniência OpenSpec é rotulada como externa, fixa e não integrada.

O aceitador designado é o operador do projeto; o root faz review-of-review e
não pode autoaceitar. A
aceitação não autoriza automaticamente commit, push, PR, execução, Wave 0,
S1B ou uma mudança de Plane.

## Rollback e reentrada

Enquanto este arquivo for `draft-pre-s1a`, ele pode ser corrigido como
planejamento. Se um futuro commit S1A aceito tocar apenas os paths declarados
no Test Design, o rollback é reverter esse commit isolado e invalidar Test
Design/revisão relacionados. Overlap com paths fora de S1A bloqueia rollback
automático e exige worktree isolado e novo plano.

Reabrir esta emenda se a autoridade superior, o baseline, o denominator ACV1,
a proveniência OpenSpec, o escopo S1A ou qualquer precondição de Wave 0 mudar.
