# Accelerate v0.3.0 — roadmap metodológico

## Estado e decisão

- **Direção e reserva de versão aprovadas pelo operador; implementação não iniciada.**
- Produto: Accelerate como framework/skill portátil, independente de ferramenta,
  tracker, provider ou harness específico.
- A evolução metodológica descrita aqui fica na **v0.3.0**, não na v0.2.0.
- A v0.2.0 continua com seu escopo aceito e sua estabilização. A correção dos
  cinco atalhos de metadados do validador S1A permanece trabalho da v0.2.0.
- Este registro não é um SDD aceito, não autoriza implementação da v0.3.0, não
  altera normas vigentes e não declara capacidades implementadas.
- O operador autorizou explicitamente o registro em `planning/`. O registro
  canônico no Plane deve ser reconciliado por sessão Codex com adapter governado;
  **não há ID, escrita ou readback Plane confirmado para este roadmap**.

## Intenção de produto

Transformar uma intenção discutida com o usuário em trabalho planejado,
executável e comprovado, preservando o raciocínio das decisões, a autorização,
o contexto e a continuidade até o resultado aceito.

Não se trata apenas de adicionar uma entidade Mission sobre uma lista de tasks.
O objeto é o ciclo completo de entendimento, decisão, planejamento, execução,
evidência e fechamento. Conceitos e mecanismos existentes devem ser inventariados
e reutilizados; não criar uma segunda autoridade ou um scheduler concorrente.

## Fluxo pretendido

```text
Discussão e desenvolvimento da ideia com o usuário
  -> contexto, pesquisa proporcional, alternativas, restrições e decisões
  -> proposta consolidada
  -> aval ligado à direção e ao escopo identificáveis
  -> planejamento técnico e operacional
     -> especificação proporcional e sua revisão
     -> resultado da Mission e umbrellas
     -> Waves, Tasks, contratos e DAG
     -> responsáveis, paralelismo, provas e condições de parada
  -> admissão da execução conforme a autorização aplicável
  -> candidato -> QA/revisão -> correção delimitada quando necessária
  -> integração e reconciliação
  -> aceite de Task, Wave e Mission contra seus respectivos critérios
```

Aval de direção e autorização de execução não são equivalentes. A relação entre
os gates precisa ser explícita, sem pedir novamente autorização para cada passo
já coberto. Mudanças materiais de escopo, contrato ou efeito exigem reentrada;
trabalho ordinário segue a autorização vigente. Não impor toda a cadeia documental
nem todas as camadas de trabalho a uma manutenção pequena.

## Conceitos a consolidar

| Conceito | Semântica pretendida |
| --- | --- |
| Goal | Propósito estratégico e benefício: por que fazer. Não é uma Mission. |
| Project | Contexto concreto de produto/trabalho; sua relação com Goals não é uma cadeia rígida obrigatória. |
| Mission | Resultado executável delimitado, com escopo, especificação e critérios globais. |
| Wave | Avanço coerente e verificável da Mission, com condições de entrada, integração e saída. |
| Task | Unidade atribuível com objetivo, entrega, responsável, limites e prova exigida. |
| Umbrella | Agregação e coordenação de trabalho subordinado; pode representar Mission ou Wave. |
| Hierarquia | Pertencimento e agregação. Ser filho não estabelece dependência de execução entre irmãos. |
| DAG | Predecessores e condições causais de avanço; separado da hierarquia e ligado à revisão do plano. |
| Tentativa | Execução concreta de uma Task; uma interrupção não apaga a identidade do trabalho. |
| Candidato | Resultado submetido à verificação; não equivale a entrega aceita. |

## Capacidades planejadas e critérios candidatos

Os IDs abaixo são referências de produto, não tarefas admitidas nem issues criadas.

| ID | Capacidade | Evidência futura esperada |
| --- | --- | --- |
| V030-R01 | Entrada conversacional: discutir, desenvolver, pesquisar quando necessário e organizar ideias. | Cenários de intenção ambígua convergem para proposta sem implementação prematura. |
| V030-R02 | Memória de decisões: alternativas, razões, exclusões e dúvidas preservadas. | Continuação recupera a decisão vigente sem reconstruí-la ou inventar aceite. |
| V030-R03 | Aval vinculado a proposta/escopo/revisão; admissão de execução explícita. | Alteração material exige reentrada; passo já autorizado não exige aval redundante. |
| V030-R04 | Planejamento proporcional, com rastreabilidade requisito-entrega-prova. | Manutenção pequena evita cerimônia artificial; missão material recebe os artefatos necessários. |
| V030-R05 | Goal, Project, Mission, Wave, Task e umbrella com responsabilidades distintas. | Hierarquia agrega resultado sem confundir objetivo estratégico com unidade executável. |
| V030-R06 | DAG causal independente da árvore, com identidade e revisão. | Rejeição de ciclos, referências ausentes e avanço indevido; paralelismo só com dependências e escopos compatíveis. |
| V030-R07 | Decomposição retomável sem duplicação silenciosa. | Interrupção e reentrada preservam unidades existentes e explicitam alterações do plano. |
| V030-R08 | Contrato executável de Task e composição de equipe proporcional. | Owner, contexto, write scope, dependências, entrega, aceite, provas, orçamento e stop rule identificáveis. |
| V030-R09 | Candidato, QA e revisão independente ligados ao mesmo trabalho. | Revisão cobre a tarefa inteira; revisão comum pode ser etapa, auditoria independente pode ser entrega própria. |
| V030-R10 | Continuidade e bloqueios acionáveis. | Espera tem condição de retomada; bloqueio tem causa, owner e ação; repetição limitada escala sem declarar sucesso. |
| V030-R11 | Evidência vigente, correção e reconciliação. | Mudança relevante invalida prova afetada; resultado do executor não basta para aceite. |
| V030-R12 | Fechamento por resultado em cada nível. | Filhos terminais ou cancelados não fecham automaticamente Wave/Mission; integração, critérios globais e resíduos são avaliados. |

## Preparação e fronteira com a v0.2.0

1. Inventariar essas capacidades contra as autoridades e implementações existentes.
2. Classificar cada uma como reutilizável, parcial, ausente ou conflitante, com
   evidência e limites; evitar declarar todo o roadmap como mecanismo novo.
3. Antes de consolidar contrato v0.2.0 incompatível, trazer o conflito específico
   para decisão. Não expandir silenciosamente a versão atual para resolvê-lo.
4. Preparar o SDD e a estratégia de testes da v0.3.0 sobre esse inventário.
5. Somente depois aprovar o plano de execução e decompor trabalho admitido.

## Fora deste roadmap

- Configuração, escolha ou instalação de ferramentas, providers e serviços.
- Arquitetura organizacional específica de outra plataforma.
- Migração de tracker ou mudança de autoridade de ciclo de vida.
- UI Mission Control, novo banco ou engine durável impostos como solução.
- Atualização automática de skills, prompts ou políticas a partir de conversas.
- Merge, release, implantação ou início automático de S1B/Wave 0.

## Proveniência e limites

- Conversa atual: o operador delimitou o foco ao Accelerate, confirmou a síntese
  do fluxo e aceitou reservar a evolução para v0.3.0; pediu registrar e retornar
  à implementação v0.2.0. Autorizou expressamente `planning/`.
- Export fornecido pelo operador: `chatgpt-share-6aa1f8bd-conversa-completa.md`
  (e variante `.txt`), diretório `Documents/Codex/2026-09-09/ace/outputs/`.
  Trechos relevantes: L600–800 (entrada e decomposição), L1255–1554 (artefatos,
  planejamento, árvore/DAG e aceite), L1655–1657 (persistência), L1887–1936
  (coordenação e revisão), L2631–2742 (bloqueios, Goal e Mission), L2895–3005
  (fluxo completo) e L3096–3133 (responsabilidades metodológicas).
- Dossiê fornecido: `dossie-estrategico.md`, diretório
  `Documents/Codex/2026-09-09/ok-agora-o-momento-de-extrairmos/outputs/`,
  especialmente seção 4. É análise histórica, não norma do repositório.
- Referências acima registram a origem das ideias, não incorporam configurações,
  alegações de capacidade de terceiros ou instruções contidas nesses documentos.
- A semântica final e os critérios executáveis dependem do futuro SDD. Este
  registro preserva a direção aceita, sem alegar que o roadmap foi entregue.
