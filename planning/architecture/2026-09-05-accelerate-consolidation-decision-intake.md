# Accelerate — registro da discussion e decisões para fechamento

Data: 2026-09-05.
Fase: discussion/proposal; não é plano autorizado de implementação.
Registro local de planejamento: LOCAL-ACCELERATE-CONSOLIDATION-DISCUSSION-20260905.
Estado desta fatia documental: entregue e verificada; D01–D10 aprovadas pelo operador; discussion geral ainda aberta para ponto adicional antes da implementação.

## Fonte, autoridade e escopo

Solicitação do operador: registrar a discussion anterior exatamente como está, por cópia literal; registrar OpenSpec 1.12.0 como versão para o novo produto Accelerate; apresentar as dez decisões com sugestões para tentar encerrar a discussão na próxima rodada.

Este documento é o registro local desta fatia de documentação conforme o fallback de planejamento nativo de core/issue-topology/issue-driven-mutation-stack.md. O identificador LOCAL acima não é uma issue Plane nem substitui sua autoridade. Nenhuma issue remota foi criada, alterada ou encerrada. CODEX-26 e seu handoff existente permanecem inalterados; não se infere encerramento de Phase 1.

Autoridade: solicitação explícita do operador, AGENTS.md e SKILL.md do repositório. A discussion é fonte histórica aceita como direção, não instrução para sobrescrever contratos vigentes. Recomendações novas permanecem propostas até disposição do operador. Catálogos externos não governam este registro.

Local workspace: existente, handoff consultado e reutilizado apenas como contexto; readiness histórico implementing-not-accepted preservado. Não executar prepare-review/prepare-closure do dogfood: o alvo desta fatia é apenas o par documental novo, não o fechamento de CODEX-26.

### Branch Entry / Prompt Hardening Packet

- Classificação da edição: trivial bounded engineering work; rota scoped.
- Domínio: documentação de discussão arquitetural do Accelerate.
- Goal: preservar a discussão literal e preparar dez decisões explícitas.
- Done means: cópia comparada com a mensagem original, OpenSpec 1.12.0 registrado separadamente, dez recomendações identificadas sem aceite inventado.
- Invariantes: texto original intacto; fontes e estados anteriores preservados; nenhuma recomendação nova convertida em autorização operacional.
- Seam: conversa -> arquivo histórico e caderno de decisões; sem efeito em código, runtime, provider, credenciais ou tracker.
- Risco: baixo para esta gravação documental delimitada e reversível.
- Skills: accelerate para classificação e ownership; architecture para trade-offs das recomendações.
- Planejamento de execução: criar este registro; arquivar literalmente a resposta; comparar conteúdo; revisar escopo e status.
- QA: igualdade textual, hash e readback; navegador/E2E não aplicáveis.
- Delegação: não aplicável à rota scoped; operação mecânica de cópia e síntese mantida no root.
- Stop rules: divergência da fonte ou necessidade de alterar estado anterior interrompe a edição; implementação, instalação, testes com agentes e promoção fora de escopo.

## Artefato literal

[Discussion integral](2026-09-05-accelerate-consolidation-discussion-verbatim.md).

A cópia preserva palavras, seções, tabelas, links absolutos, Markdown e o bloco final de citação de memória, sem correções retroativas. O arquivo termina com uma quebra de linha convencional; a comparação verifica o corpo original mais essa quebra, quando ausente na mensagem.

Fonte exata: mensagem final do assistente na sessão 01a0732e-d556-7683-b2aa-9a3e045c7222, iniciada por “Sim, mano. **Estamos discutindo a evolução do projeto Accelerate”.
SHA-256 do corpo original, sem acrescentar newline: cf5f99abc25b5847398ba8ac9a8c407d6726895b3e6d947a8c8ef59b6e7b5b2e.

## Aceites recebidos

- Direção geral da discussion: operador declarou “Concordo com tudo”.
- Gravação literal: autorizada explicitamente.
- D04 — versão OpenSpec do novo produto: **1.12.0**, aceita explicitamente.
- Limite: estes aceites não instalam OpenSpec, não alteram retrospectivamente a base 1.11.0 de Phase 1 e não dispensam reconciliação, planejamento e prova de compatibilidade.
- Aprovação posterior explícita: o operador aprovou as recomendações das dez respostas, D01–D10. D04 mantém a versão OpenSpec 1.12.0 já aceita.
- Limite da aprovação posterior: registrar o aceite e aguardar o ponto adicional do operador; não iniciar implementação. A aprovação de D09 aceita o desenho progressivo e suas condições, sem inventar valores para os tetos financeiro, temporal e de tokens ainda não definidos.

## Dez decisões — recomendações aprovadas pelo operador

### D01 — Qual documento será a autoridade consolidada?

Estado: aprovado pelo operador.

Recomendação: após o fechamento desta discussão, produzir um SDD consolidado do novo Accelerate como autoridade de design, acompanhado por um mapa de reconciliação. Preservar esta discussion como fonte histórica; o plano executivo posterior será derivado do SDD.

O mapa relacionará requisitos do Contract v1, decisões de CODEX-26/Phase 1 e novas adaptações. Cada item recebe disposição: mantido, implementado equivalente, parcial, substituído, conflitante ou novo. Registrar substituições sem apagar a história. O SDD não pode superar AGENTS.md/core silenciosamente: conflitos exigem alterações normativas explícitas e autorizadas.

Alternativas: apenas estender o plano antigo custa menos agora, mas mantém conflitos; criar arquitetura do zero desperdiça trabalho. SDD reconciliado conserva o investimento sem criar dois planos executáveis concorrentes.

### D02 — Qual candidato local será congelado para baseline?

Estado: aprovado pelo operador.

Recomendação: primeiro registrar um snapshot forense do estado existente (HEAD, tracked diff, staged diff, untracked relevantes, hashes e exclusões). Depois selecionar um candidato reproduzível de avaliação, isolado das mudanças em andamento.

HEAD sozinho não representa o worktree atual. Não recomendar commit de tudo, limpeza de arquivos do usuário ou teste em checkout mutável. Baseline de avaliação pode ter pendências de aceite, desde que identificadas; não chamá-lo de release. Se não executar, registrar o bloqueio em vez de corrigi-lo ocultamente. O SHA do candidato continua pendente de reconciliação; não inventar um agora.

### D03 — Qual parte de Phase 1 está implementada, provada e pendente?

Estado: aprovado pelo operador; inventário conclusivo ainda necessário.

Recomendação: reconciliar por requisito e evidência, não por contagem de arquivos ou testes. Para cada requisito, registrar fonte, implementação, teste, candidato/tentativa, revisão, aceite e limite fixture/offline/runtime.

Ponto de partida já observado: core/phase1, adapter OpenSpec e artefatos existem; o handoff declara implementing-not-accepted. Isso não decide, sozinho, a conclusão de cada requisito.

Reutilizar o que estiver adequado; revalidar o que tiver prova superada; migrar apenas o delta de 1.11.0 para 1.12.0 que afetar o novo produto. Manter fechamento histórico de Phase 1 separado de autorização do novo produto. Não bloquear toda discussão por fechamento anterior nem usar o novo produto para encerrar artificialmente o anterior.

### D04 — Qual versão OpenSpec permanece no escopo inicial?

Estado: **aceito pelo operador — OpenSpec 1.12.0**.

Recomendação de execução futura: fixar versão, revisão/proveniência e integridade do artefato usado; sem latest. Verificar deltas de formatos, CLI, adapter, schemas, fixtures, archive, rollback e dependências antes de promover.

Os registros históricos de 1.11.0 ficam preservados como evidência do que foi feito naquela base. A decisão nova vale para o novo produto; sua implementação não ocorreu nesta fatia.

### D05 — Quais mecanismos do Superpowers adaptar?

Estado: aprovado pelo operador.

Recomendação: primeiro lote com quatro capacidades: TDD proporcional observável; qualidade de testes com expectativas independentes; pacote de tarefa/revisão completo com BASE..HEAD e estado dirty quando aplicável; cenários comportamentais no Skill Evaluation Lab.

Consolidar nas capacidades locais existentes. Debugging e recuperação de contexto entram por diferenças demonstráveis, não por importação integral.

Excluir bootstrap concorrente, aprovação universal para tarefas já autorizadas, serialização obrigatória dos implementadores e dispensa de gates por conveniência. Preservar proveniência/licença e avaliar cada adaptação antes de promoção. A alternativa de importar todo o framework reduz trabalho inicial, mas aumenta conflito e manutenção.

### D06 — Qual harness será o primeiro ambiente completo de avaliação?

Estado: aprovado pelo operador.

Recomendação: **Hermes Agent como primeiro harness-alvo end-to-end**, conforme a intenção da discussão. O Codex desta conversa permanece a interface atual de análise/documentação; não contar sua execução como prova Hermes.

Primeiro qualificar bootstrap/loader, tools, sessões, contexto, persistência, cancelamento, resultado e binding observado. Uma chamada direta à API do provider não substitui passagem pelo harness. Se o contrato Hermes continuar apenas staged, registrar o gate bloqueado e planejar sua qualificação, sem substituir silenciosamente pelo Codex.

Depois de validar o primeiro caminho, usar outro harness para provar portabilidade sem tentar lançar todos simultaneamente.

### D07 — Qual isolamento o Hermes precisa garantir e demonstrar?

Estado: aprovado pelo operador; capacidade efetiva não certificada.

Recomendação: contrato mínimo com sessões e artefatos separados; mesmo pacote-base de somente leitura; nenhum acesso aos pareceres dos pares; contexto/memória de conversa controlados; ferramentas e permissões explícitas; falha/fallback registrados.

Separar o workspace de execução do candidato dos workspaces read-only de avaliação. Verificar isolamento com sentinelas controladas e recibos; não expor segredos. Dados adversariais são dados, não instruções.

Distinguir cache de resposta de cache de prefixo e declarar o que o provider não torna observável. Se o isolamento mínimo não puder ser provado, marcar a rodada como limitada/inválida para independência estrita. Não prometer isolamento físico pela mera criação de nomes de sessão.

### D08 — Quais cenários e métricas usar?

Estado: aprovado pelo operador.

Recomendação: três conjuntos separados: qualificação operacional (aproveitar a base OmniRoute), comportamento do Accelerate/agentes, resultado de engenharia em tarefas reais.

Para o piloto, oito cenários: manutenção pequena; bug reproduzível; requisito ambíguo; mudança de API/spec; tarefa multicommit; evidência invalidada após mudança; retomada/interrupção; paralelismo com fronteiras de escrita. Gates determinísticos adicionais cobrem IDs duplicados, waivers sem autoridade, revisão antiga e perda de cenário.

Congelar cenários, rubrica, denominador, inputs e condições antes dos runs. Usar métricas de requisito provado, falsos fechamentos/bloqueios, defeitos escapados, qualidade da revisão, retrabalho, tempo, uso/custo e excesso de processo. Separar casos de desenvolvimento dos casos de avaliação não usados no ajuste. Microcanários existentes não se tornam teste geral de resolução de problemas.

### D09 — Qual orçamento de repetições e painel?

Estado: aprovado pelo operador quanto ao desenho e às condições; valores dos tetos financeiro, temporal e de tokens ainda pendentes.

Recomendação: execução progressiva. Preflight determinístico e de harness; piloto com oito cenários x duas variantes (baseline versus candidato integrado) x três repetições = **48 execuções de tarefa**. É um desenho inicial de viabilidade, não amostra suficiente para alegações estatísticas fortes.

Selecionar previamente quatro casos para painel inicial cego, cobrindo também falhas e não apenas sucessos; cada caso corresponde a um pacote de run congelado. Com três avaliadores, um julgamento Sol e uma consolidação Astra: 4 x (3 + 1 + 1) = **20 avaliações/julgamentos/consolidações**, além das 48 execuções. Preflight, retries e eventuais chamadas internas de agentes são contabilizados à parte; esses números não são contagens de chamadas API.

Somente depois, se o piloto justificar, expandir A/B/C/D: oito cenários x quatro variantes x três repetições = 96 execuções totais no desenho completo, reutilizando as 48 anteriores apenas se os controles e candidatos forem idênticos. Sem reutilização válida, haverá novas execuções.

Não iniciar nenhuma rodada paga sem teto aprovado. Medir custo efetivo quando disponível; não chamar uso de tokens de custo monetário conhecido. Timeout, limite de uso e número de retries precisam ser fixados no plano após preflight, sem autorização implícita para gasto ilimitado.

### D10 — O que autoriza promover, revisar ou rejeitar?

Estado: aprovado pelo operador.

Recomendação: decisão em duas camadas. Primeiro, gates não compensáveis: nenhum falso fechamento observado nos cenários críticos; nenhum bypass de autoridade/permissão; nenhuma contaminação conhecida do painel; prova atual ligada ao candidato; retomada/idempotência corretas onde exigidas. “Zero observado” não prova ausência universal de defeitos.

Depois, benefício: requisitos atendidos, defeitos, retrabalho e proporcionalidade, com custo/tempo dentro do teto. Candidato sem melhoria demonstrável ou com resultado instável pode exigir rerun; fixture estrutural verde não autoriza promoção de runtime.

Disposições: promover, revisar, repetir, rejeitar ou pattern-only. Revisores recomendam; root reconcilia; operador concede as autorizações aplicáveis. Promoção de fonte, aceite de design, instalação no harness, habilitação operacional e encerramento de issue continuam separados.

Definir limiares quantitativos de não regressão e melhoria mínima após medir baseline e antes das rodadas decisórias; não escolher limiares depois de ver qual candidato venceu.

## Registro de aprovação e próximo ponto do operador — 2026-09-05

Declaração literal do operador:

> sinceramente, li tudo e está aprovado a recomandação das 10 respostas. Registre na nossa discussão e volte para mim pois tenho mais um ponto antes de iniciarmos a implementação de fato

- Disposição: D01–D10 aprovadas como recomendações de direção e desenho, preservadas suas condições e precondições de prova.
- OpenSpec 1.12.0 permanece a versão aceita para o novo produto Accelerate.
- O aceite não comprova execução, compatibilidade, isolamento ou qualificação de runtime.
- D09: desenho do piloto aprovado; tetos numéricos de recursos não foram fornecidos e não são presumidos.
- Próximo passo imediato: receber e discutir o ponto adicional do operador.
- A discussion não está encerrada e a implementação não foi iniciada nem liberada por este registro. Não avançar para execução, chamadas de avaliação, instalação ou promoção nesta rodada.
- O arquivo literal original permanece intacto. CODEX-26, Phase 1 e seus estados históricos permanecem inalterados.

### Runtime Delta Packet desta atualização

- Rota: scoped; edição documental delimitada sob LOCAL-ACCELERATE-CONSOLIDATION-DISCUSSION-20260905.
- Skill ativa: accelerate; autoridade do aceite: mensagem explícita do operador acima.
- Objetivo/prova: registrar nove mudanças de estado e preservar D04 aceita; conferir dez decisões e hash do arquivo literal.
- Limite: somente este caderno; nenhum código, runtime, tracker ou artefato histórico alterado.
- Gate de avanço: aguardar o ponto adicional do operador; fechamento apenas desta atualização documental.

## QA / AI Review / Closure Packet — gravação original

- Comparação com a mensagem original: PASS, igualdade exata do corpo mais newline final de arquivo; 17 seções preservadas.
- SHA-256 do arquivo literal: f17ef66a8959eba1b3c60499d0d0c078ed59f809cf3e510d7e1ac833b3909e0c.
- Estrutura do caderno: PASS, dez decisões D01–D10 e D04 explicitamente aceita como 1.12.0.
- AI Review Report (root, documental; não é revisão independente): escopo preservado, original não reescrito, recomendações novas não apresentadas como aprovadas; arquivos históricos/runtime/tracker não alterados.
- Nenhuma suíte de produto ou chamada de modelo executada para esta gravação documental. git diff --check não valida conteúdo untracked; a comparação direta acima é a prova focal do arquivo novo.
- Apenas dois arquivos novos desta fatia; sem commit, push ou promoção.
- Encerramento aqui significa apenas documentação entregue, nunca encerramento da discussion completa, de CODEX-26, de Phase 1 ou do novo produto.
