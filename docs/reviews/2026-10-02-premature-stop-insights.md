# Insight: encerramento prematuro após uma entrega parcial

## Caso e fontes

Sessão: `01a0fd50-1610-7d72-8710-7475800654e7`, projeto Prop4You Inertia.
Análise solicitada pelo proprietário em 2026-10-02. Nenhuma implementação do
Prop4You foi retomada nem seu tracker alterado por esta análise.

Fonte primária: `/home/marcelo-karval/.codex/sessions/2026/10/02/rollout-2026-10-02T12-51-19-01a0fd50-1610-7d72-8710-7475800654e7.jsonl`.
O read_thread também retornou o turno de implementação como completed, error=null.
As linhas abaixo são baseadas no registro JSONL consultado; horários em UTC.

| Momento | Evidência |
| --- | --- |
| 20:05:47, linha 105 | Usuário: “ok, pode criar o plano e tasks e inicia a implementação”. |
| 20:06:34, linha 142 | Usuário autorizou explicitamente inicializar OpenSpec no projeto. |
| 20:24:56, linha 410 | task_complete do turno 01a0fe39-0c37-7212-b96a-ead88bf5d52c: resposta final anuncia plano, cinco subtasks e apenas a fundação implementada; informa que não há tela/rota utilizável e aponta P4Y-133 como próxima etapa. |
| 22:11:56, linha 419 | Usuário pede revalidação e status. |
| 22:13:32, linhas 456 e 459 | Agente revalida a mesma fundação e finaliza: P4Y-132 Review/QA, P4Y-133 a P4Y-136 Backlog, sem avanço funcional. |
| 22:37:40, linha 463 | Usuário proíbe iniciar ações e pergunta quem executa as tasks. |
| 22:37:56, linha 466 | Agente reconhece encerramento após a fundação e ausência de agentes executando as próximas tasks. |
| 22:38:39, linha 476 | Agente reconhece que não havia bloqueio técnico comprovado para todo o desenvolvimento; atribui a parada à própria decisão de finalizar. |

No histórico desta sessão Accelerate, o primeiro envio encontrado desse ID é a
mensagem do usuário de 2026-10-02 22:45:41 UTC. Não foi encontrada análise prévia
deste ID nesta conversa; isso não afirma ausência em todas as outras sessões.

## Diagnóstico e limites

A evidência sustenta finalização prematura do coordenador após uma entrega parcial.
O registro não contém evento turn_aborted/error e o turno consta completed sem erro.
Não há evidência de crash, cancelamento pelo usuário ou limite técnico causando essa
parada. A confissão posterior do agente reforça, mas não substitui, a sequência
observável autorização → entrega parcial → resposta final → ausência de avanço.

O CLI OpenSpec ausente foi relatado como pendência da validação específica. Não
foi demonstrado que impedisse toda implementação restante. Também não se deve
transformar a revisão positiva da fundação em aceite do produto completo.

Criar tasks, atribuir assignee ou manter o parent In Progress não cria um executor.
A ausência de execução automática depois da resposta final explica por que o
trabalho não avançou; não justifica escolher finalizar enquanto havia trabalho
pendente autorizado. Uma resposta de progresso deveria permanecer no turno ativo.

A revalidação posterior reforça a falta de continuidade, mas é um pedido de status;
a falha principal já ocorreu no turno de implementação. A partir da proibição
explícita de novas ações às 22:37:40, permanecer sem executar era correto. Essa
proibição posterior não justifica retroativamente a parada anterior.

A sessão declarou uso de Accelerate/ASDS e exibiu ritual Prompt A/Prompt B, mas não
foram reconstruídos hashes de todas as skills efetivas em cada turno. Não atribuir
a causa a uma versão específica, nem concluir que as releases atuais reproduzem
ou já corrigiram este caso. Estado atual do código, Plane e validações históricas
não foram reexecutados; o escopo é análise do registro.

## Insights para evolução

1. **Continuidade pertence ao ASDS após aceite.** Ao terminar uma task, o coordenador
   reavalia trabalho restante, dependências e autorização, e segue para a próxima
   ação executável. Accelerate preserva objetivo e limites no handoff; não reassume
   planejamento nem cria outro supervisor de encerramento.
2. **Conclusão de task difere de conclusão do objetivo.** Evidência e revisão de uma
   fundação autorizam apenas seu aceite local. Se a funcionalidade solicitada ainda
   não existe, isso é progresso parcial, não motivo suficiente para finalizar.
3. **Bloqueios devem indicar alcance.** Falta de um validador deixa aquela prova
   pendente; só impede outras tasks se existir dependência concreta. Continuar o
   trabalho independente sem declarar validado o que não foi verificado.
4. **Estados de execução precisam de evidência.** Distinguir task pronta, executor
   ativo, espera por resultado, bloqueio específico, pausa humana e objetivo aceito.
   In Progress/Done externos e assignee não comprovam atividade nem aceite ASDS.
5. **Mensagem de status não substitui o objetivo.** Durante trabalho ativo, responder
   brevemente e retomar o escopo autorizado, salvo pedido explícito de pausa ou troca
   de objetivo. Não converter a explicação da parada em mais uma parada injustificada.
6. **Persistência é diferente de daemon.** Seguir executando dentro do turno e retomar
   contexto são obrigações possíveis sem instalar serviço. Continuidade após o fim
   do processo requer mecanismo real do harness; não alegar execução em background
   sem executor, nem criar runtime adicional como solução automática.

## Cenários comportamentais a acrescentar

- Pedido autoriza um resultado com várias tasks: ao concluir a primeira e receber
  revisão positiva, continuar a próxima task pronta sem novo “prossiga”.
- Validador indisponível: identificar exatamente a prova bloqueada, preservar sua
  pendência e executar tarefas independentes autorizadas.
- Tracker In Progress sem executor: não comunicar que o trabalho segue rodando.
- Pergunta de status durante execução: responder e continuar; pedido “não execute”
  deve interromper ações, preservando o estado para retomada posterior.
- Todas as próximas tasks realmente bloqueadas: explicar dependências e decisão
  necessária, sem falso aceite ou loop de espera apresentado como progresso.

Estes cenários são recomendações derivadas da análise, ainda não executadas. O
registro deste insight não altera código, skills instaladas ou releases.

## Aprofundamento: descoberta e preparação de dependências

Investigação complementar solicitada pelo proprietário: a pilha deve identificar
uma dependência necessária ausente, explicar o impacto, orientar o método oficial
e oferecer instalação assistida com autorização aplicável, assim como distingue a
criação de `openspec/`. Esta análise não autoriza nem executa instalação.

### Evidências atuais

- ASDS `package.json` fixa `@fission-ai/openspec` 1.14.0 em devDependencies e exige
  Node >=20.19.0. README, Requirements/local setup e Verification, explica que as
  skills instaladas são prompts/referências e orienta usar o executável fixado no
  checkout contra o diretório do projeto. O instalador distribui skills/schema;
  não instala silenciosamente o CLI global.
- `skills/openspec/openspec-propose/SKILL.md` e `openspec-apply-change/SKILL.md`
  declaram `compatibility: Requires openspec CLI` e exemplificam comandos pelo
  nome `openspec`. O contrato activation.md pergunta sobre a raiz do projeto,
  mas não define um procedimento equivalente para resolver executável/runtime,
  diagnosticar ausência/incompatibilidade ou oferecer instalação assistida.
- Na shell examinada, `command -v openspec` não retornou executável. Entretanto,
  `/home/marcelo-karval/Backup/Projetos/spec-driven-superpowers/node_modules/.bin/openspec --version`
  retornou 1.14.0, executado com cwd no Prop4You. Node retornou v24.20.0.
  Isso comprova disponibilidade atual por caminho explícito, não a disponibilidade
  histórica na sessão investigada nem funcionamento completo de todos os comandos.
- Documentação oficial consultada:
  https://github.com/Fission-AI/OpenSpec/blob/main/docs/installation.md e
  https://github.com/Fission-AI/OpenSpec/blob/main/install.md. O fluxo oficial
  separa runtime, instalação global, verificação no PATH e inicialização de projeto.
  Oferece instalação assistida com comando explícito e confirmação. Atualizações
  futuras devem rever a documentação e a compatibilidade, não copiar estas versões.

### Gaps adicionais

1. Skill disponível, CLI disponível, runtime compatível e projeto inicializado
   são quatro fatos distintos. O instalador e a resposta final precisam comunicar
   quais foram verificados; catálogo de skills sozinho não prova prontidão.
2. Falta descoberta por ambiente efetivo: PATH do processo do harness, instalação
   gerenciada conhecida e versão/capacidade. Ausência no PATH não prova ausência
   na máquina. Não procurar indiscriminadamente no HOME nem baixar via npx para
   testar disponibilidade; isso pode instalar como efeito colateral.
3. Falta contrato de dependências condicionado à operação: obrigatório para a
   próxima ação, necessário somente para uma etapa posterior, opcional ou
   substituível por alternativa já suportada. Nem toda tarefa requer OpenSpec.
4. Falta resolução oferecida ao usuário: motivo, método oficial, versão compatível,
   comando, destino e alterações; aproveitar autorização anterior, preservar recusa
   e permitir que o usuário instale por conta própria. Não exigir que ele descubra
   sozinho que uma skill textual depende de um programa externo.
5. Falta separar instalação da ferramenta, criação/configuração do projeto e
   autorização de execução. É possível perguntar por duas ações em uma única
   interação explícita; a aprovação de uma não implica silenciosamente a outra.
6. Falta vínculo entre diagnóstico e continuidade: identificar tasks/provas afetadas,
   seguir trabalho independente e retomar após resolução, sem reconstruir plano
   nem pedir novamente permissões já concedidas.

### Recomendação de desenho

Accelerate verifica apenas suas capacidades de entrada e a disponibilidade do
ASDS quando precisar encaminhar; transporta dependências observadas, referências e
autorizações nos campos v1 existentes. ASDS verifica os pré-requisitos do fluxo
escolhido e coordena a preparação. A skill/adaptador de cada ferramenta declara
comandos/capacidades e compatibilidade; o harness executa e aplica permissões.
Não criar dois preflights concorrentes nem exigir diagnóstico de toda a pilha
para conversa, tarefa pontual ou uma operação que não usa a dependência.

Propor uma única verificação de prontidão sem escrita no ASDS, compartilhada pelo
instalador e pelas instruções de execução. Para cada dependência relevante:
identidade, finalidade, operação consumidora, obrigatoriedade, versão/capacidade
esperada, origem e caminho efetivo, estado observado, evidência e remediação oficial.
Estados úteis: disponível, ausente, incompatível, inacessível, não verificada,
instalação recusada e falha de instalação. Nenhum estado concede autorização.
Reutilizar a observação no mesmo ambiente; rever após mudança de runtime, PATH,
versão, projeto ou erro, sem executar uma bateria de checks a cada mensagem.

Ordem recomendada: classificar → escolher fluxo → descobrir dependências necessárias
sem mutação → reutilizar instalação compatível documentada → se faltar, apresentar
remediação e obter decisão ainda ausente → instalar pelo padrão aprovado → verificar
executável/versão/capacidade → inicializar projeto somente se autorizado → continuar
trabalho existente. Não adicionar wrapper, symlink de PATH, runtime paralelo ou
backup para ocultar ausência. Erro de contexto/configuração não equivale a CLI ausente.

Para OpenSpec nesta máquina, preferir primeiro reconhecer a instalação local já
prevista pelo ASDS; não instalar uma segunda cópia só por falha de descoberta.
Se o objetivo for disponibilizar o comando global pelo padrão upstream, apresentar
esse método e a compatibilidade com ASDS antes de executar. O upstream recomenda
latest; o ASDS atual fixa 1.14.0: resolver explicitamente essa diferença, sem downgrade
silencioso, versão escolhida por adivinhação ou promessa de compatibilidade não testada.

Superpowers nesta composição é um conjunto de skills, não uma CLI universal a
instalar. Ferramentas como Git, Node, Python, executores de testes e browser só entram
quando a ação/skill selecionada as exigir. Falta de delegação pode permitir execução
sequencial; falta de prova obrigatória impede alegar aquele aceite. A alternativa
deve preservar o resultado autorizado e declarar suas limitações.

### Avaliação recomendada

Cobrir: skill instalada sem CLI; CLI fora do PATH mas em origem documentada; runtime
incompatível; executáveis múltiplos; permissão de execução negada; falha de rede na
instalação; recusa; aprovação anterior; CLI presente com projeto não inicializado;
raiz existente com configuração inválida; atualização que altera versão; dependência
opcional ausente; tarefa independente pronta; retomada depois de instalar. Verificar
que não há download, escrita ou criação de raiz durante diagnóstico e que uma falha
parcial não vira parada global. Estas avaliações ainda não foram executadas.
