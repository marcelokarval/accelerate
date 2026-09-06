Sim, mano. **Estamos discutindo a evolução do projeto Accelerate — como produto, plano de controle e sistema portátil de engenharia.** OpenSpec, Superpowers, Hermes, OmniRoute, providers, modelos, agentes e subagentes entram nessa discussão como partes relacionadas dessa evolução, cada uma com uma responsabilidade diferente.

A pesquisa que você trouxe é uma base forte. Mas, confrontada com o checkout local, ela precisa de atualização em pontos importantes antes de virar um plano de implementação.

Minha conclusão principal é:

**Consolidar capacidades dentro do Accelerate continua sendo a direção correta. Porém, não devemos simplesmente retomar o Contract v1 antigo e começar suas seis waves. Primeiro precisamos reconciliar esse contrato com o trabalho posterior de OpenSpec/Phase 1, a arquitetura portátil, os contratos de agentes e o conhecimento operacional de providers e modelos que vocês já produziram.**

Abaixo está a discussion/proposal consolidada. Diferencio o que confirmei localmente, o que veio da pesquisa e o que estou propondo.

## 1. O objeto completo da discussão

O objetivo não é escolher entre três frameworks nem simplesmente aumentar o catálogo de skills.

Estamos tentando responder:

> Como o Accelerate pode transformar uma demanda em resultado verificável, selecionando processo, agentes, modelos, ferramentas e harnesses adequados, preservando autoridade, rastreabilidade, autonomia proporcional e fechamento verdadeiro?

Essa pergunta contém cinco frentes complementares:

| Frente | O que precisamos conhecer |
|---|---|
| Produto Accelerate | Classificação, hardening, planejamento, execução, revisão, correção e fechamento |
| Mecanismos de engenharia | Evolução de specs, testes, pacotes de tarefa, revisão e provas |
| Agentes e subagentes | Papéis, contexto, permissões, independência, coordenação e responsabilidade |
| Harnesses e providers | O que realmente executam, como executam e quais limitações introduzem |
| Modelos e configurações | Quais capacidades foram observadas e em quais condições são adequadas a determinado papel |

Portanto, aquela oposição entre “avaliar o Accelerate” e “conhecer os modelos” seria incorreta.

**O Accelerate é o produto sob evolução; conhecer os modelos, providers e harnesses faz parte da engenharia desse produto.** O erro seria transformar microcanários operacionais em uma classificação geral de inteligência ou competência de engenharia.

Os testes já realizados são uma base pesquisável importante. Eles não precisam provar resolução de problemas para terem valor.

## 2. Como esta análise deve ser interpretada

Esta etapa é **discussion/proposal com inspeção somente leitura**, não implementação, promoção ou encerramento de trabalho anterior.

Nesta rodada:

- confrontei pontos centrais da pesquisa com o checkout local;
- examinei documentos de autoridade, planejamento, Phase 1, harnesses, laboratório e testes;
- consultei mecanismos upstream em revisões fixadas;
- reproduzi os cinco casos do helper de waves;
- não executei a suíte completa;
- não executei um novo painel de modelos;
- não alterei código, configuração, Plane ou runtime.

Não trato os testes narrados pelo outro Astra como testes executados por mim. Também não apresento esta inspeção como auditoria linha a linha de todos os três repositórios.

A distinção de estados será fundamental durante toda a evolução:

**Proposto → implementado em fonte → testado → revisado → aceito → disponibilizado no runtime → comprovado em execução.**

Esses estados podem estar relacionados, mas não são intercambiáveis.

## 3. O que a pesquisa acertou — e o que precisa ser atualizado

### 3.1. A direção arquitetural está correta

Concordo com os pilares:

1. Accelerate permanece a autoridade.
2. OpenSpec contribui principalmente com gestão da evolução de especificações.
3. Superpowers contribui com mecanismos selecionados de testes, contexto e revisão.
4. O laboratório existente deve avaliar as adaptações.
5. Proveniência externa não concede autoridade operacional.
6. Instruções precisam ser conectadas a mecanismos verificáveis.
7. Mais documentos ou skills não demonstram melhoria de resultado.

Isso é coerente com a autoridade autocontida do repositório. [AGENTS.md](/home/marcelo-karval/Backup/Projetos/accelerate/AGENTS.md)

### 3.2. O diagnóstico histórico não descreve integralmente a cópia atual

A pesquisa examinou o Accelerate no commit `8e3fd122…`, de agosto.

O `HEAD` local que confirmei agora é:

`a9a115f6eca11a4a7f9c78d15f65f797a5109d8f`

Além disso, o worktree contém modificações e arquivos não rastreados relevantes. Logo, o denominador atual não pode ser resumido ao `HEAD`.

Entre as superfícies posteriores encontradas estão:

- `adapters/openspec/`;
- `core/phase1/`;
- `planning/openspec/`;
- catálogo e referências de harnesses;
- ontologia de assignments;
- grafo de tarefas e heartbeat;
- documentação e evidências de CODEX-26 Phase 1;
- alterações na entrada canônica de testes.

A reconciliação fica assim:

| Afirmação da pesquisa | Situação encontrada agora |
|---|---|
| Falta materializar a integração OpenSpec | Já há código e contratos locais de Phase 1; não partir do zero |
| `core/contracts/v1/` não aparece | O diretório continua ausente, mas existem contratos em outra estrutura |
| O plano antigo deve ser o eixo | É referência importante, mas precisa ser reconciliado com os planos posteriores |
| O agregador é essencialmente shell | Agora há chamadas explícitas a pytest e à lane offline de Phase 1 |
| Há fragilidades no helper de waves | Reproduzidas novamente |
| A revisão possui fallback limitado ao último commit | Continua presente |
| O teste “semantic” verifica âncoras documentais | Continua sendo verificação estrutural |
| Integração de harness requer prova operacional | Continua correto; Hermes é declarado como contrato staged |

**Ausência do caminho antigo não significa ausência de implementação equivalente. Presença de implementação equivalente também não significa entrega aceita.**

### 3.3. O estado local ainda não autoriza afirmar encerramento

O handoff local registra:

- CODEX-26 em andamento;
- readiness `implementing-not-accepted`;
- ausência de autorização para chamadas remotas naquele pacote;
- nenhuma alegação de aceite, deploy ou encerramento da Phase 1.

Isso é uma declaração documental local, não uma consulta nova ao Plane. Ainda assim, impede tratar a evolução posterior como algo simplesmente concluído. [Handoff local](/home/marcelo-karval/Backup/Projetos/accelerate/.accelerate/review/handoff-summary.md)

## 4. Contract v1: preservar a intenção, reconciliar a implementação

A pesquisa identificou corretamente o valor do Contract v1:

- evidências tipadas;
- revisão explícita de requisitos;
- invalidação de provas;
- dependências;
- reruns seletivos;
- fechamento transacional;
- gates proporcionais;
- avaliação comportamental.

Também identifiquei no master plan a referência obrigatória a workflows externos do Superpowers. Isso precisa ser reconciliado com a autoridade local, não interpretado como autorização para devolver o bootstrap ao framework externo. [Master plan Contract v1](/home/marcelo-karval/Backup/Projetos/accelerate/planning/executive/accelerate-contract-v1-master-plan.md)

Mas há uma atualização decisiva: o trabalho posterior de Phase 1 já aborda contratos, canonicalização, hashes, replay, armazenamento de fixtures e fronteira com OpenSpec.

Por isso, proponho uma reconciliação por requisito:

| Relação encontrada | Disposição apropriada |
|---|---|
| Requisito antigo já implementado de forma equivalente | Reutilizar e vincular a implementação |
| Implementado, mas sem prova suficiente | Completar a prova, não reimplementar |
| Implementado apenas em fixture | Preservar o limite e identificar a distância até produção |
| Substituído por decisão posterior | Registrar a substituição |
| Contraditório com a arquitetura posterior | Resolver explicitamente |
| Ainda não implementado | Manter como lacuna |
| Ideia nova trazida pela consolidação | Tratar como ampliação proposta |

Isso evita dois erros caros:

- reconstruir uma fundação já existente;
- considerar o plano inteiro entregue porque uma parte foi implementada em outro diretório.

### Uma diferença concreta de versão

A pesquisa externa usa OpenSpec **1.12.0**.

O SDD local de Phase 1 fixa **1.11.0**.

Não devemos atualizar silenciosamente a dependência, os formatos ou as expectativas dos testes para fazer a implementação coincidir com a pesquisa. É necessário decidir entre manter a base autorizada, avaliar o delta de versão ou importar um mecanismo específico. [SDD local de Phase 1](/home/marcelo-karval/Backup/Projetos/accelerate/planning/architecture/2026-09-01-codex-26-phase1-openspec-core-sdd.md)

Outro limite importante: o SQLite descrito nesse SDD pertence ao **gauntlet de fixtures**. Não é uma mudança da autoridade de estado do Hermes, que permanece PostgreSQL.

## 5. O que aproveitar do OpenSpec

### 5.1. Principal contribuição: evolução controlada do comportamento esperado

O ganho não está apenas em gerar `proposal`, `design` e `tasks`.

Está em manter uma distinção consistente entre:

- comportamento vigente;
- mudança proposta;
- requisitos afetados;
- cenários preservados ou alterados;
- implementação;
- reconciliação aprovada com a especificação vigente.

Isso é particularmente útil para o Accelerate porque o próprio framework evolui: rotas, gates, papéis, adapters e regras de fechamento mudam.

Sem uma semântica de mudança, documentos novos podem contradizer os antigos sem que ninguém consiga responder qual regra substituiu qual.

### 5.2. Deltas e preservação de cenários

A proposta de aproveitar operações de adição, modificação, remoção e renomeação faz sentido. O código upstream consultado possui lógica de aplicação e validação dessas mudanças; não se resume a instruções para o agente. [Aplicação de deltas no OpenSpec](https://github.com/Fission-AI/OpenSpec/blob/e062b9572be933564ba3899d059377dfa1393e32/src/core/specs-apply.ts)

Na adaptação local, eu exigiria:

- identidade estável do requisito;
- revisão anterior identificada;
- detecção de aplicação sobre base desatualizada;
- remoções explicitamente autorizadas;
- preservação de cenários não substituídos;
- ligação entre alteração aprovada e provas que precisam ser refeitas.

Um cenário desaparecer não pode ser confundido com o requisito deixar de importar.

### 5.3. Dependência de artefatos não deve controlar tudo

O grafo de artefatos ajuda a responder:

> Tenho as definições necessárias para produzir o próximo artefato?

Ele não responde sozinho:

> A tarefa está autorizada? A implementação está correta? A wave pode fechar?

A implementação consultada de `detectCompleted()` usa existência dos outputs para compor seu conjunto de artefatos concluídos. Essa semântica serve àquele mecanismo, mas não deve virar aceite no Accelerate. [Detecção de estado upstream](https://github.com/Fission-AI/OpenSpec/blob/e062b9572be933564ba3899d059377dfa1393e32/src/core/artifact-graph/state.ts)

Proponho distinguir:

- presente;
- estruturalmente válido;
- semanticamente revisado;
- aceito pela autoridade aplicável;
- atual em relação às dependências.

Nem toda tarefa pequena precisa exibir cinco estados ao usuário. O contrato, porém, não deve confundi-los.

### 5.4. O que não absorver automaticamente

Não há justificativa demonstrada, nesta discussão, para:

- importar todo o CLI;
- manter uma segunda lista manual de tarefas;
- deixar `archive` encerrar uma issue;
- adotar Stores sem necessidade multirrepositório concreta;
- substituir o scheduler do Accelerate pelo grafo de artefatos;
- permitir que a versão upstream vigente determine o comportamento local.

Compatibilidade externa pode ser útil. Autoridade duplicada não.

## 6. O que aproveitar do Superpowers

### 6.1. TDD como sequência observada, não como declaração

A proposta de TDD verificável é boa, com proporcionalidade.

Um recibo útil precisa distinguir:

1. o teste capturou a ausência ou o defeito esperado;
2. a execução anterior falhou por esse motivo;
3. a alteração corrigiu o comportamento;
4. o teste passou;
5. as regressões relevantes permaneceram protegidas.

Falhar por importação ausente não demonstra o primeiro passo.

Também não precisamos transformar TDD em uma obrigação artificialmente idêntica para tudo:

| Mudança | Prova apropriada a considerar |
|---|---|
| Bug reproduzível | Regressão que reproduza o defeito antes da correção |
| Comportamento novo | Teste de aceitação/contrato, com red/green quando aplicável |
| Refatoração | Caracterização e preservação de comportamento |
| Configuração | Validação e prova do efeito relevante |
| Workflow ou skill | Teste de ativação e comportamento, além de integridade documental |
| Documentação normativa | Consistência e verificação dos consumidores da regra |

A regra é escolher uma prova que possa rejeitar a mudança errada.

### 6.2. Qualidade dos testes

Para cada teste importante, precisamos conseguir explicar:

> Qual defeito real faria este teste falhar?

Isso combate:

- expectativa calculada pela mesma implementação testada;
- mock que elimina justamente a fronteira crítica;
- teste verde sem execução do comportamento;
- teste textual apresentado como prova de obediência;
- teste positivo sem contraparte negativa relevante.

Testes estruturais continuam úteis. O problema é atribuir a eles um alcance que não possuem.

### 6.3. Pacotes completos de revisão

O mecanismo upstream de `BASE..HEAD` é uma melhoria concreta: ele recebe revisões identificadas, lista os commits e gera o diff do intervalo completo. [Review package do Superpowers](https://github.com/obra/superpowers/blob/b36e0829c6d0140e93cfef2ca599b1b07d4a7797/skills/subagent-driven-development/scripts/review-package)

No Accelerate, eu acrescentaria:

- tarefa e tentativa;
- requisitos e critérios de aceite;
- restrições arquiteturais;
- base e candidato completos;
- manifesto do estado não commitado, quando houver;
- testes e resultados;
- achados anteriores e suas disposições;
- exclusões declaradas.

**`BASE..HEAD` resolve tarefas com múltiplos commits, mas não captura sozinho um worktree dirty.** Essa limitação é especialmente relevante no estado atual do projeto.

Outro ponto local: a skill orienta entregar ao revisor somente diff e scans. Isso evita compartilhar a narrativa do implementador, mas também pode privar o revisor do contrato necessário para avaliar conformidade. [Revisão local](/home/marcelo-karval/Backup/Projetos/accelerate/skills/review/requesting-code-review/SKILL.md)

Independência não significa ausência de requisitos. Significa ausência de influência indevida sobre o julgamento.

### 6.4. Conflitos a rejeitar na adaptação

Devemos preservar:

- rotas proporcionais;
- autonomia já autorizada;
- implementadores paralelos quando os escopos forem realmente independentes;
- root como responsável pela integração e revisão da revisão;
- gates obrigatórios mesmo quando um achado seja inconveniente;
- evidências duráveis fora de workspaces temporários descartáveis.

Não devemos importar um segundo bootstrap, uma entrevista obrigatória para toda tarefa ou uma serialização universal.

## 7. Os achados reproduzidos e sua prioridade real

Reexecutei os cinco probes do helper local:

| Entrada | Resultado atual |
|---|---|
| `done` sem prova | `pass=true`, `advance` |
| Dois `done` com o mesmo ID | `advance`, denominador 2 |
| `done` + `waived` sem justificativa, threshold 50% | `advance` |
| Lista vazia | `block` |
| Tarefa `failed` | `correct` |

O helper calcula o denominador pelo tamanho da lista recebida. Não verifica, nessa função, a identidade dos alvos contra um manifesto congelado. [Código reproduzido](/home/marcelo-karval/Backup/Projetos/accelerate/global-runtime/accelerate/scripts/wave_gate_report.py)

A conclusão precisa continuar delimitada:

**Esse helper não é suficiente como certificador de conclusão. Não reproduzi um bypass do fechamento completo do Accelerate.**

A prioridade depende de seu consumidor:

- se apenas resume dados já validados, precisa declarar essa dependência;
- se autoriza avanço diretamente, a correção é mais urgente;
- se a função está obsoleta, precisamos retirar a ambiguidade de autoridade;
- se é projeção gerada, a correção futura deve começar na fonte governante.

Há ainda um princípio importante: percentual de cobertura não pode compensar gate obrigatório.

Uma wave com 99% de cobertura pode continuar bloqueada pelo único requisito crítico não atendido. Dispensa também precisa identificar motivo, autoridade, alcance e eventual validade temporal.

## 8. Testes e CI: uma lacuna mudou de forma

A crítica histórica sobre o agregador precisa ser atualizada.

O `tests/all.sh` atual:

- exige a presença de determinados testes Python;
- executa explicitamente alguns deles via pytest;
- executa a lane offline de Phase 1;
- depois percorre os scripts shell;
- mantém a execução real do OpenSpec como opt-in separado.

Portanto, já existe avanço na integração das provas Python. [Agregador atual](/home/marcelo-karval/Backup/Projetos/accelerate/tests/all.sh)

Por outro lado, o workflow inspecionado continua instalando explicitamente apenas `ripgrep` antes de chamar o agregador. Não encontrei ali uma instalação explícita das dependências Python. Isso indica uma questão de reprodutibilidade a verificar, **não prova que a CI remota esteja falhando**. [Workflow atual](/home/marcelo-karval/Backup/Projetos/accelerate/.github/workflows/accelerate-tests.yml)

A proposta deve separar as lanes:

1. integridade documental;
2. schemas e invariantes;
3. comportamento determinístico dos componentes;
4. integração offline;
5. integração real com ferramentas;
6. comportamento de agentes;
7. resultado de engenharia;
8. runtime e fechamento.

Uma lane aprovada não deve dar cobertura fictícia às outras.

## 9. A base pesquisável de providers e modelos é parte essencial do produto

Aqui está a integração com o que você vinha defendendo desde o início.

A matriz do OmniRoute já organiza observações úteis sobre:

- disponibilidade;
- formato de respostas;
- tool calling;
- JSON;
- admissão de contexto;
- modalidades;
- streaming;
- consistência;
- latência;
- comportamento de rotas e aliases;
- controles solicitados de cache e memória.

Isso pode fundamentar decisões do Accelerate. [Matriz de capacidades](/home/marcelo-karval/.hermes/apps/references/omniroute/model-capability-test-matrix.md)

Mas precisamos preservar a interpretação exata:

- uma tool call forçada não prova escolha autônoma correta de ferramentas;
- um fragmento de patch não prova correção executável;
- um microproblema lógico não constitui avaliação ampla de resolução de problemas;
- QA sobre texto extraído não prova leitura visual nativa de PDF;
- catálogo não prova admissão real de toda a janela;
- ausência de anotação de memória não prova isolamento;
- uma falha uniforme do endpoint não deve ser atribuída automaticamente aos modelos.

**Não houve, nessa bateria, qualificação de capacidade geral de resolução de problemas.** Houve observação de capacidades operacionais e microcomportamentos delimitados.

### 9.1. A unidade de conhecimento deve ser uma configuração observada

Não basta registrar:

> Modelo X suporta ferramentas.

O registro útil é algo como:

> Nesta revisão do harness e adapter, pela rota Y do provider Z, solicitando modelo X e esforço E, esse cenário passou sob estas condições.

Os campos relevantes incluem:

- modelo solicitado;
- identidade efetiva observável e seu grau de comprovação;
- provider, rota e protocolo;
- harness e versão;
- adapter e revisão;
- esforço solicitado e observabilidade do esforço efetivo;
- ferramentas e permissões;
- modalidade;
- cenário e rubrica;
- resultado de transporte e resultado semântico;
- latência e uso/custo quando disponíveis;
- tentativas, retries e fallback;
- data e artefatos de evidência;
- limites da conclusão.

Isso permite pesquisar:

> Quais configurações têm evidência recente suficiente para este papel neste harness?

É mais útil para o produto do que um ranking universal.

### 9.2. A matriz não deve virar política automaticamente

Proponho quatro degraus:

| Degrau | Significado |
|---|---|
| Observado | O teste produziu este resultado |
| Qualificado para um escopo | A evidência atende uma rubrica delimitada |
| Elegível para um papel | Atende os requisitos daquela função e contexto |
| Admitido operacionalmente | A configuração foi aprovada para uso naquele runtime |

Uma rota pode passar um canário e continuar não admitida.

Uma rota pode ser elegível para pesquisa simples e não para revisão crítica.

E a elegibilidade precisa poder expirar ou ser suspensa quando provider, adapter, modelo ou comportamento mudarem.

### 9.3. Cuidado com scores entre grupos

A fórmula documentada utiliza, entre outros componentes, a menor mediana do ranking do próprio provider. Além disso, os denominadores variam entre baterias.

Consequentemente, ordenar scores de grupos diferentes não cria automaticamente uma comparação global controlada.

Esses scores são úteis como resumos locais, preservadas suas condições. Para decidir roteamento, prefiro:

1. cumprir capacidades obrigatórias;
2. verificar confiabilidade e frescor;
3. considerar evidência no papel;
4. otimizar custo e latência entre os elegíveis.

Um score alto não deve compensar uma capacidade obrigatória ausente.

## 10. Agentes, subagentes e harnesses: o que precisa permanecer separado

Proponho manter esta distinção explícita:

| Elemento | Responsabilidade |
|---|---|
| Skill | Procedimento ou conhecimento acionável |
| Perfil de agente | Papel, instruções e capacidades desejadas |
| Assignment | Trabalho concreto, limites, entradas e saídas |
| Adapter | Tradução para primitivas do harness |
| Instância em execução | Processo/sessão que realiza o trabalho |
| Recibo | Evidência do que foi realmente invocado e produzido |

Uma skill não se transforma automaticamente em subagente. Um perfil não prova uma instância ativa. Um papel “reviewer” não garante isolamento.

A arquitetura portátil deve definir requisitos sem presumir equivalência entre runtimes:

- contexto independente;
- ferramentas disponíveis;
- escopo de escrita;
- identidade;
- cancelamento;
- heartbeat;
- retomada;
- orçamento;
- entrega de resultados;
- erro e reconciliação.

Cada adapter declara e prova como satisfaz esses requisitos — ou informa que não os satisfaz.

### Hermes especificamente

A referência local do Hermes declara **staged contract only** e adverte que uma projeção gerada não prova loader, callability ou autorização. [Contrato atual do Hermes](/home/marcelo-karval/Backup/Projetos/accelerate/references/harnesses/hermes.md)

Assim, a proposta “via Hermes Agent” exige duas verificações diferentes:

1. o Hermes consegue realizar as chamadas necessárias?
2. o Accelerate está efetivamente carregado e governando essa execução pelo caminho declarado?

Uma chamada bem-sucedida a um modelo não resolve a segunda pergunta.

hcom, caso seja adotado, entra na fronteira de comunicação e coordenação. Não substitui contratos de identidade, escopo, evidência ou fechamento, nem deve virar dependência universal sem decisão específica.

## 11. Arquitetura consolidada proposta

A arquitetura que considero mais coerente é:

- **núcleo semântico:** autoridade, requisitos, riscos, gates, estados e fechamento;
- **planejamento e specs:** comportamento vigente, mudanças e dependências de artefatos;
- **execução:** tarefas, tentativas, waves e conflitos;
- **evidências:** proveniência, validade, revisão e invalidação;
- **catálogo de capacidades:** conhecimento observado e elegibilidade;
- **agentes e assignments:** papéis e contratos de trabalho;
- **adapters:** tradução para runtimes e backends;
- **laboratório:** avaliação das mudanças no próprio Accelerate.

A proposta dos três grafos deve ser preservada:

| Grafo | Pergunta |
|---|---|
| Artefatos | O que precisa estar definido antes de produzir este artefato? |
| Tarefas | O que pode executar agora e com qual concorrência? |
| Evidências | O que precisa ser refeito quando uma dependência muda? |

Eles devem compartilhar vínculos identificáveis, sem virar três autoridades concorrentes.

A cadeia de rastreabilidade central seria:

**Requisito/revisão → cenário → mudança → tarefa/tentativa → candidato → teste/prova → revisão → disposição → decisão de fechamento.**

Não proponho que todos esses registros sejam documentos manuais separados. Quanto mais puderem ser derivados de eventos e artefatos já existentes, menor será a carga operacional.

## 12. Evidência: autenticidade, atualidade e suficiência

A pesquisa enfatiza corretamente hashes e imutabilidade. Acrescento uma distinção:

**Um hash prova correspondência de conteúdo; não autentica, sozinho, quem executou ou autorizou a ação.**

Para fechamento, precisamos responder:

- a qual candidato a evidência pertence?
- quem a produziu e por qual caminho?
- qual requisito ela cobre?
- a execução realmente terminou?
- o resultado foi interpretado corretamente?
- alguma mudança posterior a invalidou?
- ela é suficiente para o gate em questão?

### Invalidação não deve ser nem insuficiente nem indiscriminada

Se muda uma spec, podem ser invalidados critérios e revisões sem mudança de código.

Se muda uma dependência, testes de integração podem precisar de rerun.

Se chega uma revisão da tentativa anterior, ela deve ser reconciliada com a atual; não aprová-la automaticamente nem descartá-la sem verificar se o achado persiste.

Se muda apenas uma documentação sem efeito normativo, não necessariamente tudo precisa rodar novamente.

A invalidação seletiva só é segura quando os vínculos são confiáveis. Na ausência deles, o sistema deve ampliar a prova exigida ou declarar a incerteza.

### Fechamento transacional precisa tratar efeitos externos incertos

Fechar envolve mais do que gravar `done`:

- verificar o candidato esperado;
- conferir gates obrigatórios;
- aplicar a transição uma única vez;
- registrar o recibo;
- confirmar o resultado;
- tratar interrupções e retomadas.

Um timeout durante escrita externa não demonstra que nada aconteceu. O adapter precisa reconciliar o estado antes de repetir a ação.

## 13. O laboratório deve avaliar três coisas diferentes

O Skill Evaluation Lab existente já prevê baseline, candidato, avaliação cega, custo, tempo e decisões de promover, revisar, repetir, rejeitar ou aproveitar apenas o padrão. Não precisamos criar outro laboratório concorrente. [Laboratório existente](/home/marcelo-karval/Backup/Projetos/accelerate/core/workflows/skill-evaluation-lab.md)

Proponho organizar suas avaliações em três planos.

### Plano A — qualificação operacional

Pergunta:

> A combinação de provider, modelo, adapter e harness suporta o que este papel exige?

A base OmniRoute alimenta esse plano, com limites de transporte e harness explícitos.

### Plano B — comportamento do Accelerate e dos agentes

Pergunta:

> O sistema classificou, delegou, preservou escopo, buscou evidência e respeitou os gates?

Exemplos:

- não usar processo excessivo numa tarefa simples;
- não aceitar `done` sem prova;
- não compartilhar pareceres entre avaliadores cegos;
- não usar fallback oculto;
- não tratar silêncio como prova de falha;
- não promover uma tentativa antiga.

### Plano C — resultado de engenharia

Pergunta:

> O trabalho resolveu o problema, satisfez os requisitos e evitou defeitos?

Aqui entram tarefas reais, testes independentes, defeitos escapados e retrabalho.

**Esse terceiro plano precisa ser criado ou ampliado com desenho específico; ele não pode ser declarado já coberto pelos microcanários existentes.**

### Comparação das adaptações

O desenho A/B/C/D da pesquisa é bom:

- A: Accelerate baseline;
- B: baseline + mecanismos de specs;
- C: baseline + mecanismos de testes/revisão;
- D: combinação.

Para isolar o efeito do framework, manteríamos configurações comparáveis de modelo, esforço, harness, permissões e repositório.

Depois, outra avaliação poderia variar modelos ou harnesses. Misturar todas as mudanças de uma vez dificultaria saber o que causou a melhoria.

Precisamos também evitar escolher a variante apenas pelo desempenho nos próprios exemplos usados para desenvolvê-la: casos separados de avaliação e repetições são importantes.

## 14. Como ajustar o painel cego Gemini/Sonnet/Terra → Sol → Astra

O desenho continua útil, mas não constitui, sozinho, um benchmark de melhoria do Accelerate.

Ele produz **pareceres independentes sobre evidências**. A prova comportamental vem das execuções, testes e rastros examinados.

### Primeira camada: mesmo contrato

Gemini, Sonnet e Terra podem ser candidatos ao painel, sujeitos à qualificação operacional.

Mas eu retiraria da primeira rodada a distribuição de especialidades diferentes. Se um recebe “procure arquitetura” e outro “procure testes”, as diferenças deixam de ser atribuíveis apenas à avaliação independente.

Para uma comparação limpa:

- mesmo pacote-base;
- mesma rubrica;
- mesmas perguntas;
- mesmo acesso às evidências;
- nenhum parecer anterior;
- nenhuma informação desnecessária sobre os outros participantes;
- saídas separadas.

Uma rodada especializada pode existir depois, claramente identificada como outra etapa.

### Independência precisa de comprovação proporcional

Precisamos distinguir:

- sessões separadas;
- memória de conversa separada;
- contexto inicial controlado;
- ausência de acesso aos pareceres;
- diretórios e resultados isolados;
- cache de resposta;
- cache técnico de prefixo;
- mecanismos internos do provider que não conseguimos observar.

Não é honesto prometer “nenhum cache compartilhado em nenhuma camada” quando o harness ou provider não permite demonstrar isso.

O objetivo é evitar contaminação dos pareceres e registrar o isolamento realmente garantido.

### Sol como julgador

O Sol recebe o pacote original e os pareceres anonimizados para:

- verificar alegações;
- separar achado, hipótese e preferência;
- identificar omissões;
- resolver divergências quando a evidência permitir;
- manter como inconclusivo o que não puder ser resolvido.

Maioria não substitui prova. Um único parecer pode apontar o defeito decisivo.

### Astra como consolidador

O Astra recebe o conjunto e mantém:

- revisão do julgamento;
- reconciliação com as fontes;
- separação entre concluído, parcial, bloqueado e não iniciado;
- recomendações e critérios de aceite;
- fechamento apenas dentro da autoridade concedida.

A serialização também tem custo e risco de ancoragem. Portanto, Sol → Astra deve ser avaliado como mecanismo útil, não assumido como superior em qualquer tarefa.

Para uma consolidação arquitetural como esta, faz sentido como candidato. Não precisa virar rito obrigatório para manutenção trivial.

## 15. Critérios para saber se melhoramos o Accelerate

As métricas precisam equilibrar qualidade e custo:

| Dimensão | Medida útil |
|---|---|
| Correção | Requisitos satisfeitos com prova válida |
| Defeitos | Falhas que escaparam da execução e revisão |
| Fechamento | Aprovações indevidas e bloqueios indevidos |
| Revisão | Achados corretos, falsos positivos e omissões |
| Rastreabilidade | Evidências associadas ao candidato e tentativa corretos |
| Resiliência | Recuperação após interrupção sem duplicar efeitos |
| Proporcionalidade | Processo desnecessário em tarefas pequenas |
| Eficiência | Tempo, uso, custo e ciclos de correção |
| Portabilidade | Comportamento equivalente nas capacidades comuns dos harnesses |

Fixtures prioritários da pesquisa devem ser mantidos:

- prova ausente;
- IDs duplicados;
- dispensa sem autoridade;
- teste verde que não verifica o requisito;
- revisão de apenas um commit;
- evidência superada por mudança de código ou spec;
- revisão tardia de tentativa antiga;
- perda de cenário;
- escopos de escrita conflitantes;
- interrupção durante fechamento;
- repetição de operação já aplicada;
- tarefa simples recebendo processo excessivo.

Eu acrescentaria:

- modelo efetivo diferente do solicitado;
- fallback não informado;
- ferramenta declarada, mas indisponível;
- execução fora do bootstrap esperado;
- vazamento de parecer para outro avaliador;
- maioria de revisores concordando com uma conclusão sem prova;
- regra crítica presente na skill, mas ignorada na execução.

## 16. Como organizar a evolução sem criar outro roadmap concorrente

As seis waves históricas continuam uma boa estrutura de raciocínio, mas não devem ser tratadas como autorização automática nem renomear silenciosamente as fases posteriores.

A ordem lógica seria:

| Etapa de reconciliação | Resultado esperado |
|---|---|
| Autoridade e estado atual | Identificar fonte, candidato, decisões e trabalho ainda não aceito |
| Contratos existentes | Mapear equivalências, lacunas e conflitos entre Contract v1 e Phase 1 |
| Adaptações selecionadas | Escolher mecanismos OpenSpec/Superpowers e suas diferenças locais |
| Rastreabilidade e gates | Ligar requisitos, tentativas, candidatos, provas e revisões |
| Avaliação | Comparar comportamento e resultado sem confundir modelos com variantes |
| Runtime | Qualificar o caminho Hermes e demais adapters necessários |
| Promoção | Admitir somente o que tiver aceite e prova suficientes |

Antes de transformar isso em plano sólido, precisamos decidir:

1. Qual documento será a autoridade consolidada após a reconciliação?
2. Qual candidato local será congelado para baseline?
3. Qual parte de Phase 1 está implementada, provada e ainda pendente de aceite?
4. Qual versão OpenSpec permanecerá no escopo inicial?
5. Quais mecanismos do Superpowers serão efetivamente adaptados?
6. Qual harness será o primeiro ambiente completo de avaliação?
7. Qual isolamento o Hermes consegue garantir e demonstrar?
8. Quais cenários e métricas serão usados?
9. Qual orçamento de repetições e painel será aceitável?
10. Quais resultados autorizam promoção, revisão ou rejeição?

Essas são decisões de proposta. Não estou solicitando que você responda dez perguntas agora nem transformando-as em bloqueio para a discussão.

Também precisamos preservar, para cada adaptação, origem, revisão, licença, responsável local e diferenças introduzidas. Atualizações upstream devem passar por comparação e avaliação, não sobrescrever automaticamente decisões do Accelerate.

## 17. Minha recomendação final

**Aprovo a direção da consolidação como proposta arquitetural. Não considero a pesquisa histórica suficiente para autorizar diretamente sua implementação.**

O núcleo da proposta fica assim:

> Evoluir o Accelerate como autoridade autocontida e portátil de engenharia, incorporando gestão de mudanças de especificação, testes e revisão verificáveis, e seleção de agentes baseada em evidência operacional e comportamental — com adapters que provem a execução e um fechamento que não dependa apenas do relato dos agentes.

Preservaria:

- hardening e rotas proporcionais;
- root ownership;
- waves e paralelismo independente;
- revisão da revisão;
- laboratório existente;
- separação entre semântica e runtime.

Fortaleceria:

- evolução das specs;
- pacotes completos de tarefa e revisão;
- qualidade e alcance declarado dos testes;
- identidade de candidato e tentativa;
- validade e invalidação das provas;
- conhecimento pesquisável de providers/modelos/harnesses;
- qualificação dos caminhos reais de execução.

Não faria:

- instalação de frameworks concorrentes como autoridades;
- atualização silenciosa de versão;
- reconstrução de trabalho já existente;
- promoção baseada em score de microcanários;
- declaração de isolamento por configuração nominal;
- fechamento de Phase 1 ou CODEX-26 por esta análise.

**O próximo produto da discussão deve ser uma matriz reconciliada de capacidades e decisões — existente, implementado, provado, aceito, pendente e proposto. Só depois dela faz sentido fechar o plano de execução.**

Essa é a visão completa: não estamos montando uma coleção de prompts nem fazendo uma competição abstrata entre modelos. Estamos amadurecendo o Accelerate para que ele saiba **o que exigir, quem pode executar, em qual ambiente, com quais provas e sob quais condições pode afirmar que terminou**.

<oai-mem-citation>
<citation_entries>
MEMORY.md:697-709|note=[Continuidade das distincoes entre skills, perfis, instancias, isolamento e autoridade do root]
</citation_entries>
<rollout_ids>
01a05a66-f24a-7480-b28e-dc1c2ed6b659
</rollout_ids>
</oai-mem-citation>
