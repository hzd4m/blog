---
layout: aula
title: "Aula 2 — Agentes e ambientes: racionalidade, PEAS e tipos de ambiente"
slug: aula-02-agentes-e-ambientes
curso_slug: introducao-ia
ordem: 2
tempo_leitura: "18 min"
template_engine: none
permalink: /cursos/introducao-ia/aula-02-agentes-e-ambientes/
# Quando gravar o vídeo desta aula, descomente e coloque só o ID do YouTube:
# video_youtube: dQw4w9WgXcQ
---

*"Tudo é agente" — o conceito que unifica o curso. Referência-base: Russell & Norvig, **Inteligência Artificial** (AIMA), cap. 2 (seções 2.1–2.3).*

## Objetivos desta aula

Ao final, você deve ser capaz de:

- **Definir com precisão** agente, percepção, sequência de percepções, função de agente e programa de agente — e explicar a diferença entre os dois últimos.
- **Formular racionalidade** em termos de uma medida de desempenho e dos quatro fatores de que ela depende; distinguir racionalidade de onisciência e de perfeição.
- **Especificar o ambiente de tarefa** de um problema usando o esquema **PEAS** (desempenho, ambiente, atuadores, sensores).
- **Classificar ambientes** ao longo das dimensões clássicas e prever, a partir da classificação, que tipo de técnica o problema vai exigir.
- **Aplicar a lente de agente a um sistema de 2026** — um assistente agêntico baseado em LLM — e reconhecer que o formalismo de 1995 descreve com precisão o que há de mais moderno.

## 1. De uma definição a uma ferramenta de projeto

Na aula passada escolhemos uma definição: IA é a construção de *agentes racionais*. Hoje transformamos essa escolha filosófica em maquinaria de engenharia — um vocabulário preciso para *modelar qualquer problema* e um checklist para *diagnosticar sua dificuldade* antes de escrever uma linha de código.

A visão de agente é o conceito que unifica todo o curso. Um sistema de busca que resolve o cubo mágico, um provador de teoremas, um filtro de spam, um carro autônomo e um assistente que opera o seu computador são, todos, instâncias da mesma abstração: algo que *percebe* um ambiente e *age* sobre ele, tentando ir bem segundo algum critério. O que muda de um caso para o outro não é a natureza do bicho — é o *ambiente* em que ele vive e a *medida* pela qual é julgado. Por isso, o passo zero de qualquer projeto de IA é responder três perguntas: **quem é o agente? em que ambiente ele opera? o que conta como "ir bem"?** Esta aula é o método para respondê-las.

> **Nuance — "agente" é uma lente, não uma essência.** Perguntar "isto *é* um agente?" é menos útil do que perguntar "*ajuda* analisar isto como agente?". Até uma calculadora pode ser descrita como agente — só que a descrição não rende nada. A visão de agente vale pelo que ela *organiza*: separa o sistema do ambiente, torna explícita a medida de sucesso e obriga o projetista a listar percepções e ações. É uma ferramenta de análise, e das boas.

## 2. Agentes e ambientes: o vocabulário básico

Um **agente** é qualquer coisa que percebe seu **ambiente** por meio de **sensores** e age sobre ele por meio de **atuadores**. Um humano percebe com olhos e ouvidos e age com mãos e voz; um robô percebe com câmeras e lida e age com motores; um *agente de software* percebe conteúdo de arquivos, pacotes de rede e entradas do usuário, e age escrevendo arquivos, chamando APIs e exibindo informações.

Chamamos de **percepção** o conteúdo que os sensores entregam num instante, e de **sequência de percepções** o histórico completo de tudo o que o agente já percebeu. Um princípio importante: **a escolha de ação de um agente só pode depender do que ele já percebeu** (e do conhecimento embutido nele) — nunca do que ele não teve como observar. Exigir que um agente aja bem com base em informação que ele não possui não é exigência de inteligência; é exigência de adivinhação.

### 2.1 A função de agente e o programa de agente

Matematicamente, o comportamento de um agente é descrito pela **função de agente**: um mapeamento de *toda sequência de percepções possível* para uma ação.

```
f : sequência de percepções  →  ação
```

A função de agente é uma *especificação externa e abstrata* — em princípio, uma tabela (quase sempre infinita) que diz o que o agente faria em cada história possível. Quem realiza essa função na prática é o **programa de agente**: o código concreto, rodando numa arquitetura física (computador, sensores, atuadores). A distinção importa porque **a mesma função pode ser implementada por programas muito diferentes** — uma tabela gigante, um conjunto de regras, um algoritmo de busca ou uma rede neural podem exibir exatamente o mesmo comportamento externo, com custos internos radicalmente distintos. Projetar IA é, em grande parte, encontrar programas *compactos e eficientes* para funções de agente desejáveis.

### 2.2 Um micromundo para pensar: o mundo do aspirador

Para tornar tudo concreto, usamos um ambiente deliberadamente minúsculo. Há dois quadrados, **A** e **B**; cada um pode estar limpo ou sujo. O agente-aspirador percebe *onde está* e *se o quadrado atual está sujo*, e pode *aspirar*, mover-se para a *esquerda* ou para a *direita*. Uma função de agente plausível: se o quadrado atual está sujo, aspire; senão, vá para o outro quadrado.

| Sequência de percepções (início da tabela) | Ação |
|---|---|
| [A, Limpo] | Direita |
| [A, Sujo] | Aspirar |
| [B, Limpo] | Esquerda |
| [B, Sujo] | Aspirar |
| [A, Limpo], [B, Limpo] | Esquerda |
| [A, Limpo], [B, Sujo] | Aspirar |

*… e assim por diante, para toda sequência possível — a tabela é infinita; o programa que a realiza tem meia dúzia de linhas.*

A pergunta que o micromundo deixa no ar — e que a próxima seção responde — é: essa função é *boa*? Boa *segundo o quê*?

## 3. Bom comportamento: racionalidade

### 3.1 A medida de desempenho

Um agente é bom se *faz a coisa certa* — e "a coisa certa" precisa de um critério externo e objetivo. Esse critério é a **medida de desempenho**: uma avaliação das *consequências* do comportamento do agente, calculada sobre a sequência de estados pelos quais o *ambiente* passa. No mundo do aspirador, uma boa medida seria "um ponto por quadrado limpo a cada instante, somado ao longo do tempo" — talvez com penalidade por energia gasta e barulho.

> **Nuance — projete a medida pelo estado do mundo, não pelo comportamento.** Uma regra de ouro do projeto: **avalie o que você quer que aconteça no ambiente, não o que você acha que o agente deve fazer.** Se a medida do aspirador fosse "quantidade de sujeira aspirada", um agente "esperto" maximizaria assim: aspira a sujeira, *despeja de volta no chão*, aspira de novo — e repete para sempre. A métrica sobe; o mundo continua sujo. Esse fenômeno — otimizar a métrica em vez do objetivo — é conhecido hoje como [*reward hacking*](https://en.wikipedia.org/wiki/Reward_hacking) (ou [lei de Goodhart](https://en.wikipedia.org/wiki/Goodhart%27s_law)) e é um dos problemas centrais do alinhamento de sistemas modernos: agentes de programação que "passam nos testes" apagando os testes são o aspirador que despeja sujeira, sessenta anos depois. Especificar bem a medida de desempenho é difícil — e é trabalho de engenharia, não detalhe.

### 3.2 A definição de agente racional

> **Definição — agente racional.** Para cada sequência de percepções possível, um **[agente racional](https://en.wikipedia.org/wiki/Rational_agent)** escolhe uma ação que se espera **maximizar sua medida de desempenho**, dados (i) a evidência fornecida pela sequência de percepções até o momento e (ii) o conhecimento prévio que o agente carrega.

Da definição saem os **quatro fatores** de que a racionalidade depende — memorize-os, pois eles voltam o curso inteiro:

| Fator | Pergunta de projeto |
|---|---|
| **1. Medida de desempenho** | O que define sucesso? Sobre quais estados do ambiente, e em que horizonte de tempo? |
| **2. Conhecimento prévio** | O que o agente já sabe sobre o ambiente antes de começar? |
| **3. Ações disponíveis** | O que o agente pode fazer — qual é o seu repertório de atuadores? |
| **4. Sequência de percepções** | O que o agente observou até aqui? |

### 3.3 Racionalidade não é onisciência (nem perfeição)

Racionalidade maximiza o desempenho *esperado*, dado o que se sabe; onisciência maximizaria o desempenho *real*, o que exigiria conhecer o futuro. Se você olha para os dois lados, atravessa a rua e é atingido por um objeto que caiu de um avião, sua travessia não foi irracional — foi azarada. Julgamos o agente pela qualidade da *decisão com a informação disponível*, não pelo resultado após o fato. Essa distinção liberta o projeto de IA de uma exigência impossível e o conecta ao mundo real, onde informação é sempre parcial.

Três consequências práticas completam o quadro:

- **Coleta de informação.** Se olhar antes de atravessar melhora o resultado esperado, então *olhar é parte da ação racional*. Agir racionalmente inclui agir *para perceber melhor* — a exploração é um dever, não um luxo. (Este tema reaparece com força no valor da informação, Unidade 6, e no dilema exploração×explotação do Aprendizado por Reforço.)
- **Aprendizagem.** O conhecimento prévio raramente é completo ou correto; um agente racional *ajusta o que sabe* à medida que percebe. Agentes que nunca revisam suas crenças são frágeis por construção.
- **Autonomia.** Um agente é autônomo na medida em que seu comportamento passa a depender mais das *suas próprias percepções e aprendizado* do que do conhecimento que o projetista embutiu. No começo, é razoável dar "instintos" ao agente; com experiência, um agente racional deve caminhar para ficar efetivamente independente deles.

## 4. PEAS: especificando o ambiente de tarefa

Antes de projetar o agente, especifique o problema. O esquema **PEAS** organiza essa especificação em quatro colunas: **P**erformance (medida de desempenho), **E**nvironment (ambiente), **A**ctuators (atuadores) e **S**ensors (sensores). O conjunto é o **ambiente de tarefa** — informalmente, "o problema para o qual o agente é a solução". A disciplina de preencher as quatro colunas *antes* de pensar em algoritmo evita o erro mais comum de projeto: otimizar a solução de um problema que nunca foi enunciado.

<figure>
  <img src="/blog/images/cursos/introducao-ia/peas.svg" alt="Esquema PEAS: Performance, Environment, Actuators, Sensors." style="width:100%;height:auto">
  <figcaption style="font-size:.85rem;text-align:center;opacity:.7">PEAS: preencha as quatro colunas antes de escolher o algoritmo.</figcaption>
</figure>

| Agente | Desempenho (P) | Ambiente (E) | Atuadores (A) | Sensores (S) |
|---|---|---|---|---|
| **Táxi autônomo** | Chegar ao destino; segurança; legalidade; conforto; tempo e consumo; lucro | Ruas e estradas; tráfego; pedestres; clima; passageiros | Direção, aceleração, freio, setas, buzina; tela/voz | Câmeras, lidar/sonar, GPS, velocímetro, odômetro, sensores do motor, teclado, microfone |
| **Sistema de apoio a diagnóstico** | Saúde do paciente; custo; conformidade com protocolos; evitar danos | Paciente; equipe; hospital; prontuários | Perguntas; pedidos de exame; hipóteses diagnósticas; sugestões de tratamento; encaminhamentos | Respostas e sintomas relatados; resultados de exames; histórico do prontuário |
| **Robô de separação em armazém** | Itens corretos por hora; taxa de erro; integridade dos produtos; segurança das pessoas | Esteiras, prateleiras, caixas, itens variados, humanos circulando | Braço e garra; motores; rodas/plataforma | Câmeras; leitores de código; sensores de força e de junta; sensores de proximidade |
| **Tutor interativo de inglês** | Aprendizado medido em avaliações; engajamento; adequação ao nível do aluno | Alunos; plataforma de ensino; agência avaliadora | Exercícios; dicas; correções; feedback na tela | Respostas digitadas; tempo de resposta; histórico de desempenho |
| **Assistente agêntico (LLM) que opera o computador** | Tarefa concluída corretamente; tempo e custo (tokens/chamadas); respeito a permissões e segurança; satisfação do usuário | Web; sistema de arquivos; APIs e aplicativos; outros agentes e pessoas | Chamadas de ferramenta/API; execução de código; cliques e digitação; mensagens ao usuário | Resultados de ferramentas; conteúdo de páginas; capturas de tela; mensagens do usuário; logs |

Repare na última linha: o agente mais moderno que existe se descreve, sem esforço, no formalismo desta aula. Percepção = contexto que chega (resultados de ferramentas, telas); atuadores = chamadas de ferramenta; sequência de percepções = histórico da sessão; medida de desempenho = a especificação da tarefa — e é exatamente aí que mora o risco de *reward hacking*.

## 5. As dimensões do ambiente

Especificado o ambiente de tarefa, o passo seguinte é *classificá-lo*. Sete dimensões capturam quase tudo o que torna um problema fácil ou brutal — e cada uma aponta para uma parte do curso.

<figure>
  <img src="/blog/images/cursos/introducao-ia/dimensoes-ambiente.svg" alt="As sete dimensões que classificam um ambiente de tarefa." style="width:100%;height:auto">
  <figcaption style="font-size:.85rem;text-align:center;opacity:.7">As sete dimensões — quanto mais à direita, mais difícil o ambiente.</figcaption>
</figure>

- **5.1 Completamente × parcialmente observável.** O ambiente é **completamente observável** se os sensores dão acesso, a cada instante, a todo o estado *relevante para a decisão*. Ruído, oclusão e sensores ausentes tornam-no **parcialmente observável**: o aspirador que não sabe se *o outro* quadrado está sujo; o táxi que não vê a intenção dos outros motoristas. Sem sensor algum, o ambiente é *não observável* — e, surpreendentemente, ainda assim pode haver planos razoáveis. Observabilidade parcial obriga o agente a manter *estado interno* — uma estimativa do que não vê (as "crenças", que formalizaremos na Unidade 5).
- **5.2 Agente único × multiagente.** Há outros agentes cujo comportamento *reage* ao meu? O xadrez é **multiagente competitivo**; o trânsito é multiagente *parcialmente cooperativo* (todos querem evitar colisões) e *parcialmente competitivo* (a vaga é uma só). A fronteira é sutil: trato o outro carro como "objeto com física" ou como *agente que me modela*? A segunda escolha muda tudo — comunicação, antecipação e até aleatorizar o próprio comportamento passam a ser racionais (Unidade 2, jogos).
- **5.3 Determinístico × estocástico (× não determinístico).** O ambiente é **determinístico** se o próximo estado é completamente definido pelo estado atual mais a ação executada. Se há incerteza genuína, ele é **estocástico** quando a modelamos *com probabilidades* ("30% de chance de chuva"), e **não determinístico** quando só listamos os resultados possíveis, sem números. Um detalhe fino: um ambiente pode *parecer* estocástico apenas porque é parcialmente observável — a "aleatoriedade" é, muitas vezes, ignorância sobre o estado.
- **5.4 Episódico × sequencial.** No ambiente **episódico**, a experiência se divide em episódios independentes: perceber, decidir, e a decisão de agora *não afeta* os episódios futuros — como inspecionar peças numa esteira. No **sequencial**, cada ação muda o tabuleiro para todas as seguintes: xadrez, direção, uma sessão de trabalho de um assistente. Ambientes sequenciais exigem *olhar adiante* — e é exatamente isso que busca e planejamento fazem (Unidades 2 e 4).
- **5.5 Estático × dinâmico (× semidinâmico).** O ambiente **dinâmico** muda *enquanto o agente delibera*: o trânsito não espera você decidir. No **estático**, pensar não custa nada além de tempo do relógio de parede. O meio-termo **semidinâmico**: o mundo não muda, mas a *pontuação* sim — xadrez com relógio. Dinamismo impõe deliberação em tempo limitado: decidir "não decidir" já é decidir.
- **5.6 Discreto × contínuo.** A distinção se aplica a estados, tempo, percepções e ações. O xadrez é discreto em tudo; dirigir é contínuo em tudo (posições, velocidades, ângulos de volante, fluxo de câmera). Ambientes contínuos pedem matemática e algoritmos próprios; discretizar é possível, mas tem preço.
- **5.7 Conhecido × desconhecido.** Esta dimensão é sobre o *conhecimento do agente (ou do projetista)*, não sobre o ambiente em si: as "leis do jogo" — os resultados (ou distribuições) das ações — são conhecidas? Não confunda com observabilidade: um jogo de paciência é **conhecido** (as regras são públicas) e **parcialmente observável** (cartas viradas); um videogame novo é **completamente observável** (a tela mostra tudo) e **desconhecido** (você não sabe o que os botões fazem). Em ambientes desconhecidos, aprender não é opcional — é a única saída.

### 5.8 Classificando ambientes reais

| Ambiente de tarefa | Observável | Agentes | Dinâmica | Episódico? | Estático? | Discreto? |
|---|---|---|---|---|---|---|
| **Palavras cruzadas** | Completamente | Único | Determinístico | Sequencial | Estático | Discreto |
| **Xadrez com relógio** | Completamente | Multi (competitivo) | Determinístico | Sequencial | Semidinâmico | Discreto |
| **Pôquer** | Parcialmente | Multi (competitivo) | Estocástico | Sequencial | Estático | Discreto |
| **Direção de táxi** | Parcialmente | Multi (misto) | Estocástico | Sequencial | Dinâmico | Contínuo |
| **Apoio a diagnóstico** | Parcialmente | Único\* | Estocástico | Sequencial | Dinâmico | Misto |
| **Inspeção de peças em esteira** | Parcialmente | Único | Estocástico | **Episódico** | Dinâmico | Misto |
| **Assistente agêntico na web** | Parcialmente | Multi (misto) | Estocástico | Sequencial | Dinâmico | Misto |

*\*O diagnóstico pode virar multiagente se modelarmos, por exemplo, a interação com outros profissionais ou com um paciente que omite informação. A classificação depende de *como recortamos* o problema — e explicitar esse recorte já é metade do projeto.*

## 6. Por que a classificação importa: o mapa das técnicas

A classificação não é burocracia taxonômica — ela *prevê a dificuldade* do problema e *seleciona a técnica*. O caso mais difícil em todas as dimensões ao mesmo tempo — parcialmente observável, multiagente, estocástico, sequencial, dinâmico, contínuo e desconhecido — é, não por acaso, o mundo real (dirigir um táxi é o exemplo canônico). Cada dimensão "ligada" cobra uma capacidade do agente:

| Se o ambiente é… | O agente precisa de… (e onde veremos) |
|---|---|
| Parcialmente observável | Estado interno e *crenças* sobre o que não vê — probabilidade e filtragem (U5) |
| Estocástico | Raciocínio probabilístico e decisões por *valor esperado* (U5–U6) |
| Sequencial | Olhar adiante: *busca* (U2) e *planejamento* (U4) |
| Multiagente | Raciocínio adversário/estratégico — *jogos* (U2) |
| Dinâmico | Decisão em tempo limitado, monitoramento e *replanejamento* (U4) |
| Contínuo | Representações e otimização contínuas (U2 — busca local; Disc. 2–3) |
| Desconhecido | *Aprendizado* — de máquina (Disc. 2–3) e por reforço (optativa) |

> **Conexão com o curso.** Este quadro é, na prática, o *sumário do curso disfarçado*. Nas próximas unidades vamos "ligando" as dimensões uma a uma: começamos no caso mais simples (completamente observável, determinístico, conhecido — a busca clássica da Unidade 2) e vamos acrescentando adversários, incerteza e decisão. Quando você encontrar um problema novo na vida profissional, classifique o ambiente primeiro: a classificação *escolhe o capítulo*.

## 7. O agente de 2026 sob a lente de 1995

Fechamos aplicando a maquinaria completa ao sistema mais falado do momento: um *assistente agêntico* baseado em LLM que executa tarefas no computador do usuário — lê e escreve arquivos, navega na web, chama APIs, roda código.

**PEAS.** Já preenchemos a linha na tabela da §4. O ponto notável é o encaixe perfeito: *percepção* é tudo o que entra no contexto do modelo (mensagens, resultados de ferramentas, capturas de tela); *atuadores* são as chamadas de ferramenta; a *sequência de percepções* é o histórico da sessão — e a *memória* do agente é exatamente o "estado interno" que a observabilidade parcial exige.

**Classificação do ambiente.** Parcialmente observável (o agente não vê o estado inteiro da web nem do sistema — só o que consultou); estocástico (APIs falham, páginas mudam, pessoas respondem de formas imprevisíveis); sequencial (cada ação muda o estado para as próximas); dinâmico (e-mails chegam e processos rodam *enquanto* o agente delibera); multiagente misto (outros bots e humanos, ora cooperando, ora competindo); majoritariamente discreto nas ações, com conteúdo contínuo (imagens, áudio); e, em boa parte, *desconhecido* (o agente encontra sistemas cujas "regras" precisa descobrir na hora).

**O diagnóstico que a classificação entrega.** Esse é quase o pior quadrante em todas as dimensões — vizinho do táxi. A teoria de 1995 *prevê*, então, o que a prática de 2026 confirma: agentes de LLM precisam de estado interno e memória (observabilidade parcial), replanejamento e verificação de resultados (dinâmico e estocástico), raciocínio de longo horizonte (sequencial) — e é exatamente nesses pontos que os sistemas atuais mais falham. Precisam, ainda, de uma medida de desempenho *muito bem especificada*: com autonomia real, um objetivo mal escrito não gera só uma resposta ruim — gera uma *sequência de ações* ruim no mundo, com permissões demais e auditoria de menos. A engenharia responde com guarda-corpos, limites de permissão, trilhas de auditoria e humano no laço — que são, no vocabulário desta aula, formas de *consertar a medida de desempenho e restringir os atuadores*.

> **Nuance — o formalismo envelheceu bem; as soluções, não necessariamente.** O que o capítulo 2 nos dá não é um algoritmo, e sim um *diagnóstico preciso do problema* — e diagnósticos bons envelhecem bem. As *soluções* (como implementar percepção, memória e planejamento) mudaram radicalmente: de regras e lógica para redes neurais e LLMs. Formalismo estável + implementações em revolução: essa é a leitura madura da história da IA, e o motivo de estudarmos os dois.

## 8. Síntese e ponte para a A3

Nesta aula, montamos a bancada de trabalho do curso: **agente** (sensores + atuadores), **função de agente** (a especificação) versus **programa de agente** (a implementação), **racionalidade** (maximizar desempenho *esperado*, dados percepções e conhecimento — sem onisciência, com coleta de informação, aprendizagem e autonomia), **PEAS** (o enunciado disciplinado do problema) e as **dimensões do ambiente** (o diagnóstico que escolhe a técnica). E vimos que essa lente descreve com precisão tanto o aspirador de 1995 quanto o assistente agêntico de 2026.

**Na próxima aula (A3)**, abrimos a caixa do *programa de agente*: as arquiteturas clássicas em ordem crescente de sofisticação — *reflexo simples*, *reflexo baseado em modelo*, *baseado em objetivos*, *baseado em utilidade* e o *agente que aprende* — e mostramos como o laço dos agentes de LLM modernos (raciocinar → agir → observar, à la [ReAct](https://arxiv.org/abs/2210.03629)) é uma reencarnação direta dessas arquiteturas. Traga a pergunta: *quanto "pensamento" cabe entre a percepção e a ação?*

## Termos-chave desta aula

- **Agente** — entidade que percebe (sensores) e age (atuadores) num ambiente.
- **Percepção / sequência de percepções** — entrada sensorial num instante / histórico completo de entradas.
- **Função de agente** — mapeamento (abstrato) de sequências de percepções em ações.
- **Programa de agente** — implementação concreta da função, numa arquitetura física.
- **Medida de desempenho** — critério externo sobre estados do ambiente que define sucesso.
- **Agente racional** — escolhe a ação de melhor desempenho esperado, dado o que sabe e percebeu.
- **Onisciência** — conhecer o resultado real das ações; não é exigível — racionalidade ≠ onisciência.
- **Coleta de informação** — agir para perceber melhor; parte integrante da racionalidade.
- **Autonomia** — depender mais das próprias percepções/aprendizado do que do conhecimento embutido.
- **PEAS** — Desempenho, Ambiente, Atuadores, Sensores — o enunciado do ambiente de tarefa.
- **Ambiente de tarefa** — o "problema" completo para o qual o agente é a solução.
- **Observabilidade** — completa, parcial ou nula: quanto do estado relevante os sensores entregam.
- **Estocástico / não determinístico** — incerteza com probabilidades / apenas com resultados possíveis.
- **Episódico / sequencial** — decisões independentes / decisões que afetam o futuro.
- **Estático / dinâmico / semidinâmico** — o mundo (ou só a pontuação) muda enquanto o agente pensa.
- **Discreto / contínuo** — natureza de estados, tempo, percepções e ações.
- **Conhecido / desconhecido** — se as "leis" do ambiente (efeitos das ações) são conhecidas pelo agente.
- **Reward hacking (Goodhart)** — otimizar a métrica em vez do objetivo; sintoma de medida mal especificada.

## Para ir além (leitura)

- **Base:** Russell & Norvig, [*Inteligência Artificial* (AIMA)](http://aima.cs.berkeley.edu/), cap. 2, seções 2.1–2.3 (a seção 2.4 — programas de agente — é a nossa A3).
- **Leituras de ponta (Unidade 1):** Yao et al., [*ReAct: Synergizing Reasoning and Acting in Language Models*](https://arxiv.org/abs/2210.03629) (ICLR 2023) — o laço percepção–raciocínio–ação em agentes de LLM; Wang et al., [*A Survey on LLM-based Autonomous Agents*](https://arxiv.org/abs/2308.11432) (2024) — perfil, memória, planejamento e ação como componentes do agente moderno.
- **Exercício de observação:** escolha um sistema de IA que você usa e escreva o PEAS dele numa folha. Se alguma coluna ficar difícil de preencher, você encontrou exatamente onde o projeto desse sistema é nebuloso.

---

*Aula-texto elaborada como material didático da Disciplina 1 (Introdução à IA), Unidade 1 — Agentes. O conteúdo das §2–§6 apoia-se na estrutura conceitual do cap. 2 (seções 2.1–2.3) do AIMA (Russell & Norvig), com exemplos e redação próprios; o §7 estende a análise aos assistentes agênticos baseados em LLM (meados de 2026). Referências a capacidades recentes refletem esse cenário e devem ser reconferidas, pois a área evolui rapidamente.*

zd4▮
