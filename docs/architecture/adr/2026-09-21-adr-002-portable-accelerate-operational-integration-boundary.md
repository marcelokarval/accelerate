# ADR 002: Fronteira de Integração entre o Accelerate Portátil e Complementos Operacionais

- **Status**: PROPOSED / pendente de revisão externa de conteúdo
- **Data**: 2026-09-21
- **Decisores**: Direção de separação arquitetural solicitada pelo operador (Karval); redação normativa submetida a revisão independente de conteúdo
- **Contexto**: Branch `docs/a0-preserve-portable-accelerate-integration-boundary`, pós-auditoria v0.3.2 no repositório `marcelokarval/accelerate`

---

## 1. Contexto e Problema

O Accelerate é concebido como um método e control plane de governança de engenharia portátil, independente de um runtime ou orquestrador particular. Ele provê classificação de rotas de execução, planejamento proporcional, especificações técnicas, gestão de tarefas e uma esteira rigorosa de provas.

Com o surgimento de complementos operacionais voltados a harnesses específicos (como o ecossistema `accelerate-omo-plugin` para OpenCode, OpenChamber e OmO), faz-se necessário demarcar com precisão a fronteira de autoridade e as responsabilidades de cada camada, evitando:
1. Reduzir o Accelerate a documentação passiva ou subordinar seu núcleo a um plugin de runtime específico;
2. Transformar o complemento operacional em um segundo proprietário concorrente dos requisitos de produto;
3. Impor cerimônias burocráticas excessivas (como a exigência compulsória de todas as fases ou de múltiplos documentos formais para demandas atômicas e triviais);
4. Misturar os papéis de coordenação de tarefas em sessões com o uso flexível de subagentes nativos;
5. Confundir código de adapter mantido no repositório com ativação operacional efetiva no host.

---

## 2. Decisão Arquitetural

### 2.1 Autoridade Metodológica e Complementaridade Operacional
- Quando o método Accelerate estiver explicitamente selecionado para um trabalho, ele detém a autoridade metodológica sobre:
  - Escopo, não-objetivos e critérios de aceitação;
  - Planejamento proporcional à complexidade da demanda;
  - Revisão cética independente;
  - Ordenação e suficiência das provas;
  - Critérios de conclusão e autorização de fechamento da entrega.
- OmO é o orquestrador utilizado no ambiente operacional informado pelo operador, atuando como o executor primário das sessões. O núcleo portátil do Accelerate não depende exclusivamente de OmO e permanece compatível com múltiplos adaptadores.
- O complemento operacional provê suporte de infraestrutura para o harness: gerenciamento de identidade e papéis, nomeação de sessões, alocação de workers e worktrees físicas, observabilidade, coleta de retornos e facilitação de integração controlada.
- O complemento não é proprietário dos requisitos de produto nem orquestrador concorrente; a sessão OmO executa o método Accelerate quando este for ativado.

### 2.2 Topologia: Workers-Sessões e Subagentes
- A organização de trabalho admite a hierarquia:
  - **Master**: Conduz a visão global, governança da entrega, conciliação documental, acompanhamento dos workers, integração e encerramento da missão.
  - **Workers-Sessões**: Sessões de trabalho distintas, atuando em worktrees ou contextos isolados dentro de um escopo ou slice atribuído pelo Master.
  - **Subagentes**: Recursos nativos acionados dentro da sessão do worker.
- **Definição Normativa de Subagentes**:
  > Workers-sessões podem coordenar subagentes dentro da frente ou slice atribuído. Subagentes podem pesquisar, implementar, escrever testes, executar verificações ou produzir relatórios conforme o contrato, permissões e capacidades efetivamente suportados pelo harness. Nenhum deles herda automaticamente autoridade global, publicação, integração final ou fechamento da missão. Escrita concorrente e consumo de recursos permanecem delimitados; revisão independente do candidato exige separação apropriada do implementador.
- Essa flexibilidade não autoriza recursão desgovernada nem concessão de capacidades inexistentes no adaptador ativo. Demandas triviais preservam execução direta sem imposição forçada dessa hierarquia.

### 2.3 Neutralidade de Operações e Adaptação de Runtime
- Os adaptadores de runtime (`adapters/runtime/*`) traduzem capacidades conceituais em ações concretas do harness.
- O core do Accelerate não embute nomes proprietários de ferramentas locais, portas de rede ou identificadores exclusivos de provedores.
- A integração de código de uma worktree ao branch de trabalho é uma capacidade coordenada pelo Master e executada pelas rotinas apropriadas do adaptador selecionado, sem que nomes de comandos específicos atuem como regras normativas universais do core.

### 2.4 Coerência Documental e Dinâmica de Feedback (PRD ➔ ADR ➔ SDD ➔ Tasks)
- **PRD**: Estabelece o resultado esperado, valor, escopo e critérios de aceitação.
- **ADR Vigente**: Registra a decisão técnica fundamentada e suas restrições. ADRs substituídos permanecem no histórico apontando para o documento sucessor.
- **SDD**: Reconcilia os requisitos do PRD e as restrições do ADR em interfaces, contratos e desenho técnico implementável.
- **Tasks (DAG)**: Decompõem a implementação em unidades atômicas executáveis.
- **Proporcionalidade**: Nem toda alteração exige a produção simultânea dos quatro artefatos. Pequenas correções e tarefas delimitadas utilizam documentação proporcional.
- **Feedback da Execução**: As tarefas não reescrevem requisitos silenciosamente. Caso descobertas práticas durante a execução revelem incompatibilidades, o worker deve reportar a situação, abrindo uma revisão explícita e autorizada de PRD, ADR ou SDD. A parte afetada só avança após a conciliação documental e atualização das provas correspondentes.

### 2.5 Preservação da Doutrina de Rotas e Provas
- As rotas de execução do Accelerate mantêm sua classificação canônica: `direct-fast-path`, `scoped` e `orchestrated`. A dimensão de esforço de raciocínio (`low`, `medium`, `high`, `xhigh`) é tratada separadamente, conforme a política de reasoning vigente.
- A esteira de provas preserva a sequência conceitual canônica (provas de implementação, QA de backend/frontend, browser truth quando aplicável, regressão persistente e conciliação forense), sem transformar a menção a essa sequência em exigência artificial para edições puramente documentais.

### 2.6 Fronteira de Integração Futura
- A integração entre o Accelerate e complementos operacionais deve ocorrer por meio de interfaces versionadas com consumo explícito.
- Notações existentes no repositório — como o *Dense-Dispatch Skeleton YAML v1* e o *Caveman Return v1* (documentados em `docs/architecture/dense-dispatch-and-caveman-protocol.md`) — constituem propostas arquiteturais em processo de avaliação e refinamento. Não devem ser tratadas nesta decisão como protocolo obrigatório pré-qualificado entre produtos.
- O ponto de integração futuro entregará referências metodológicas versionadas, contexto e escopo delimitado para assignments, além de critérios para recepção de candidatos e resultados verificáveis.

### 2.7 Tratamento de Dívida Técnica e Escopo de Auditoria
- O arquivo `adapters/runtime/opencode/accelerate-plugin.js` representa código de adapter interno mantido sob dívida técnica no repositório. Sua existência no código-fonte não constitui evidência de que esteja ativo ou operacionalmente instalado no host do operador.
- As anomalias e fragilidades apontadas na auditoria v0.3.2 (G01 a G08) são registradas formalmente como backlog próprio de aprimoramento do Accelerate, devendo ser sanadas com testes e correções no próprio repositório, sem presunção de que o desenvolvimento de um plugin externo as elimine automaticamente.

---

## 3. Consequências

- **Clareza de Responsabilidades**: O Accelerate preserva seu papel de governança metodológica e controle de qualidade, enquanto o complemento operacional fornece ferramentaria de suporte sem conflito de soberania.
- **Flexibilidade Controlada**: Workers podem empregar subagentes locais de forma produtiva para tarefas técnicas e de teste, mantendo delimitada a autoridade de integração final.
- **Evolução Desacoplada**: A evolução do núcleo do Accelerate e a dos complementos de runtime ocorrem de forma independente, consumindo-se por interfaces delimitadas.
