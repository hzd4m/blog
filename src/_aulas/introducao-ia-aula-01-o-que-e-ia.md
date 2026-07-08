---
layout: aula
title: "Aula 1 — O que é IA: fundamentos, história e estado da arte"
slug: aula-01-o-que-e-ia
curso_slug: introducao-ia
ordem: 1
tempo_leitura: "15 min"
template_engine: none
permalink: /cursos/introducao-ia/aula-01-o-que-e-ia/
# Quando gravar o vídeo desta aula, descomente e coloque só o ID do YouTube:
# video_youtube: dQw4w9WgXcQ
---

*Da IA simbólica aos LLMs e à "IA agêntica". Referência-base: Russell & Norvig, **Inteligência Artificial** (AIMA), cap. 1.*

## Objetivos desta aula

Ao final, você deve ser capaz de:

- **Definir** o que é Inteligência Artificial e explicar por que a definição não é uma trivialidade, mas uma escolha que orienta o que construímos.
- **Distinguir os quatro enfoques** clássicos da IA, organizados em duas dimensões — fidelidade ao humano *versus* racionalidade, e pensamento *versus* comportamento.
- **Situar o campo no tempo**: reconhecer os grandes marcos, os ciclos de entusiasmo e frustração (os "invernos"), e conectar a IA clássica ao estado da arte de hoje — aprendizado profundo, LLMs e a virada agêntica.
- **Enxergar o fio do curso**: entender por que esta aula abre tudo o que vem depois (agentes, busca, lógica, incerteza e decisão).

## 1. Por que começar por "o que é IA?"

A Inteligência Artificial é, ao mesmo tempo, um dos sonhos mais antigos da humanidade e uma das tecnologias mais recentes. Essa dupla natureza é a razão de começarmos pela pergunta aparentemente filosófica: *o que é, afinal, inteligência artificial?*

E a pergunta não é acadêmica. A resposta que adotamos determina o que tentamos construir, como medimos sucesso e o que aceitamos como "funcionando". Se definirmos IA como "imitar o ser humano", avaliaremos nossos sistemas por quão humanos parecem. Se a definirmos como "agir de modo a atingir o melhor resultado possível", avaliaremos por desempenho mensurável. Como veremos, foi a segunda escolha que organizou o campo moderno — e é ela que estrutura este curso inteiro.

Esta primeira aula é a fundação conceitual da disciplina. Tudo o que vem em seguida — resolver problemas por *busca*, representar conhecimento em *lógica*, raciocinar sob *incerteza*, tomar *decisões* — são respostas técnicas a uma única pergunta de engenharia: *como construímos algo que age de forma inteligente?* Ao final, você verá que a "IA agêntica" que domina as manchetes de 2026 é, no fundo, a versão moderna e movida a modelos de linguagem de uma ideia com décadas de idade: o *agente racional*.

## 2. O problema da definição: o que é "inteligência"?

Não existe uma definição única e consensual de inteligência — nem para humanos, nem para máquinas. Em vez de fixar uma lista de requisitos, a IA se organizou historicamente em torno de duas perguntas que, cruzadas, produzem quatro escolas de pensamento:

1. **O objetivo é reproduzir o ser humano ou alcançar a racionalidade?** Um sistema pode ser julgado por quão fielmente reproduz o comportamento ou o raciocínio humano, ou por quão bem faz "a coisa certa" — atinge seus objetivos da melhor forma possível, independentemente de fazê-lo como um humano faria.
2. **O foco é o pensamento ou o comportamento?** Podemos nos interessar pelo processo interno (raciocínio, deliberação) ou pelo resultado externo observável (a ação).

Cruzando os dois eixos — *humano × racional* e *pensamento × comportamento* — obtemos a matriz que estruturou o campo.

<figure>
  <img src="/blog/images/cursos/introducao-ia/matriz-4-enfoques.svg" alt="Matriz 2×2 dos quatro enfoques da IA: pensar/agir como humano e pensar/agir racionalmente." style="width:100%;height:auto">
  <figcaption style="font-size:.85rem;text-align:center;opacity:.7">A matriz que organizou o campo — a Seção 3 destrincha cada quadrante.</figcaption>
</figure>

## 3. Os quatro enfoques da IA

|  | Fidelidade ao humano | Racionalidade ("fazer o certo") |
|---|---|---|
| **Pensamento** (processo interno) | **Pensar como humano** — modelagem cognitiva: reproduzir os passos de raciocínio da mente humana. | **Pensar racionalmente** — as "leis do pensamento": raciocínio correto pela lógica. |
| **Comportamento** (ação externa) | **Agir como humano** — o Teste de Turing: comportar-se de modo indistinguível de um humano. | **Agir racionalmente** — o agente racional: agir para obter o melhor resultado esperado. |

### 3.1 Agir como humano — o Teste de Turing

Em 1950, [Alan Turing propôs](https://doi.org/10.1093/mind/LIX.236.433) contornar a pergunta "as máquinas podem pensar?" por um teste operacional: uma máquina é considerada inteligente se um interrogador humano, conversando por texto, não conseguir distingui-la de uma pessoa. Para passar nesse teste, uma máquina precisaria dominar **processamento de linguagem natural**, **representação de conhecimento**, **raciocínio automatizado** e **aprendizado de máquina**. O "Teste de Turing total" acrescenta a capacidade de perceber e manipular o mundo físico, exigindo também **visão computacional** e **robótica**. Não por acaso, essas seis capacidades correspondem, grosso modo, às grandes subáreas da IA.

> **Nuance — imitar não é o objetivo de engenharia.** Turing foi visionário, mas "parecer humano" raramente é a meta prática. A analogia clássica: a engenharia aeronáutica não busca construir máquinas que voem "tão parecido com pombos que enganem outros pombos". Buscamos *voar bem*, não imitar aves. Do mesmo modo, buscamos *agir de modo inteligente*, não necessariamente imitar pessoas. Por isso o Teste de Turing, embora célebre, não guia a construção da maioria dos sistemas modernos.

### 3.2 Pensar como humano — a modelagem cognitiva

Se o objetivo é fazer a máquina pensar *como* um humano, primeiro é preciso saber como humanos pensam — via introspecção, experimentos psicológicos e, hoje, neuroimagem. Essa é a interface entre a IA e a **ciência cognitiva**: modelos computacionais são usados tanto para construir sistemas úteis quanto para testar teorias sobre a mente. Programas pioneiros como o [*General Problem Solver*](https://en.wikipedia.org/wiki/General_Problem_Solver) (Newell e Simon) não se contentavam em resolver problemas: buscavam reproduzir a *sequência* de passos que um humano seguiria. É um enfoque legítimo, mas seu objetivo — entender a cognição humana — difere do objetivo de engenharia de construir o melhor sistema possível.

### 3.3 Pensar racionalmente — as "leis do pensamento"

A tradição que remonta a Aristóteles e seus silogismos busca codificar o "raciocínio correto": dado que certas premissas são verdadeiras, quais conclusões se seguem necessariamente? Essa linha deu origem à **lógica** formal e à tradição *logicista* da IA — representar o conhecimento em lógica e derivar conclusões por inferência (tema central da nossa Unidade 3). Ela enfrenta, porém, dois obstáculos:

- **(a) Formalizar o conhecimento informal é difícil.** Boa parte do que sabemos é incerto, vago ou cheio de exceções — e a lógica clássica lida mal com isso. (A resposta moderna é a probabilidade, nossa Unidade 5.)
- **(b) "Solúvel em princípio" não é "solúvel na prática".** Mesmo problemas com solução lógica garantida podem exigir tempo astronômico por causa da explosão combinatória. Saber que existe uma resposta não basta se não conseguimos calculá-la a tempo — a distinção entre *tratável* e *intratável* é decisiva na IA.

### 3.4 Agir racionalmente — o agente racional

Um **agente** é algo que percebe seu ambiente e age sobre ele. Um **agente racional** é aquele que age para atingir o melhor resultado esperado — ou, sob incerteza, o melhor resultado *esperado* em média — dado o que ele sabe. Este é o enfoque que a IA moderna e este curso adotam, por duas razões:

- **É mais geral do que as "leis do pensamento".** A inferência lógica correta é *uma* forma de ser racional, mas não a única: há ações racionais que não passam por deliberação explícita (um reflexo de retirar a mão do fogo é racional sem ser fruto de um silogismo). Agir racionalmente engloba raciocinar corretamente como caso particular, e vai além.
- **É mais adequado ao desenvolvimento científico.** A racionalidade é definida por um padrão externo e mensurável — uma **medida de desempenho** —, ao passo que "ser humano" é um alvo mal definido e variável. Isso permite formular a IA como um problema de otimização bem posto.

> **Nuance — racionalidade limitada.** A racionalidade *perfeita* — sempre escolher a ação ótima — é inviável em ambientes complexos, porque exigiria recursos computacionais ilimitados. Na prática, buscamos **[racionalidade limitada](https://en.wikipedia.org/wiki/Bounded_rationality)** (Herbert Simon): agir tão bem quanto possível com o tempo, a informação e a capacidade de cálculo disponíveis. Esse realismo — "fazer o melhor que dá com o que se tem" — é o que torna a IA uma disciplina de engenharia, e não apenas um ideal filosófico.

> **Definição de trabalho.** Neste curso, **Inteligência Artificial é o estudo e a construção de agentes que percebem seu ambiente e agem de modo a maximizar suas chances de atingir seus objetivos** — isto é, agentes que agem racionalmente. Essa escolha é o que unifica busca, lógica, probabilidade e decisão sob um mesmo teto.

## 4. As disciplinas que fundaram a IA

A IA não nasceu do nada: é herdeira de séculos de investigação em várias áreas. Conhecer essas raízes ajuda a entender por que o campo tem a forma que tem.

| Disciplina | Contribuições que moldaram a IA |
|---|---|
| **Filosofia** | As perguntas de origem: pode uma mente surgir de matéria? O que é conhecimento? O que é agir racionalmente? Legou a ideia de raciocínio como manipulação de símbolos e as bases da lógica e da racionalidade. |
| **Matemática** | A lógica formal (Boole, Frege); a teoria da computação e seus limites (Turing; a incompletude de Gödel); a noção de *tratabilidade* e a NP-completude; e a **probabilidade** (Bayes), a linguagem da incerteza. |
| **Economia** | Como decidir para maximizar o retorno esperado: teoria da *utilidade*, teoria da decisão, teoria dos jogos e pesquisa operacional — a base formal do "agir racionalmente" e dos processos de decisão de Markov (Unidade 6). |
| **Neurociência** | O cérebro como substrato físico da mente; o neurônio como unidade de processamento. Inspiração — não cópia — para as redes neurais artificiais. |
| **Psicologia** | Do behaviorismo à ciência cognitiva: a mente entendida como um sistema de processamento de informação, ideia central para modelar raciocínio e aprendizado. |
| **Engenharia de computadores** | O artefato físico que torna tudo possível. O crescimento exponencial do poder de cálculo (e, mais tarde, as GPUs) foi a condição material que viabilizou o aprendizado profundo. |
| **Controle e cibernética** | Sistemas que se autorregulam por *realimentação* (feedback) para atingir objetivos — parente direto da ideia de agente que percebe, age e corrige seu curso. |
| **Linguística** | A estrutura da linguagem, as gramáticas formais e o processamento de linguagem natural — a linha que conduz diretamente aos modelos de linguagem de hoje. |

## 5. Uma breve história da IA

A trajetória da IA não é uma linha reta ascendente, e sim uma sucessão de ondas de otimismo seguidas de correções de rota. Entender esse ritmo evita tanto o deslumbramento quanto o ceticismo fácil.

<figure>
  <img src="/blog/images/cursos/introducao-ia/timeline-ia.svg" alt="Linha do tempo da IA, de 1943 (gestação) a 2025 (raciocínio e agentes), marcando os dois invernos." style="width:100%;height:auto">
  <figcaption style="font-size:.85rem;text-align:center;opacity:.7">Os grandes marcos e os dois "invernos" — a lista abaixo detalha cada fase.</figcaption>
</figure>

- **1943–55 — Gestação.** McCulloch e Pitts propõem um modelo matemático de neurônio (1943); Hebb formula uma regra de aprendizado (1949); Turing publica ["Computing Machinery and Intelligence"](https://doi.org/10.1093/mind/LIX.236.433) (1950) e o seu teste; Minsky e Edmonds constroem o SNARC, um precursor de rede neural.
- **1956 — Nascimento.** No workshop de **[Dartmouth](https://en.wikipedia.org/wiki/Dartmouth_workshop)**, John McCarthy, Marvin Minsky, Claude Shannon e Nathaniel Rochester cunham o termo *Inteligência Artificial*. Newell e Simon apresentam o *Logic Theorist*, capaz de provar teoremas — a IA nasce como campo.
- **1956–74 — Entusiasmo e grandes expectativas.** O *General Problem Solver*; o programa de damas de Samuel, que *aprende* a jogar; McCarthy cria a linguagem **LISP** (1958) e concebe o *Advice Taker*; Rosenblatt introduz o [*perceptron*](https://en.wikipedia.org/wiki/Perceptron) (1958); surgem os "micromundos", como o SHRDLU de Winograd. Previsões audaciosas sobre IA em poucos anos proliferam.
- **1966–73 — Um banho de realidade (1º "inverno").** A tradução automática fracassa; a explosão combinatória derruba métodos que funcionavam em brinquedos, mas não em escala. Minsky e Papert, em [*Perceptrons*](https://en.wikipedia.org/wiki/Perceptrons_%28book%29) (1969), expõem os limites do perceptron de camada única e esfriam a pesquisa em redes neurais. Cortes de financiamento seguem (relatório Lighthill, 1973).
- **1969–86 — Sistemas baseados em conhecimento.** Em vez de métodos gerais e fracos, injeta-se conhecimento especializado: *DENDRAL* (estruturas químicas) e *MYCIN* (diagnóstico médico, já com raciocínio sob incerteza). O sistema *R1/XCON* gera economia real e a IA vira indústria — até o **2º inverno** (fim dos anos 1980), quando as promessas superam a entrega.
- **1986– — Retorno das redes neurais (conexionismo).** A redescoberta e popularização da [*retropropagação*](https://en.wikipedia.org/wiki/Backpropagation) (backpropagation) permite treinar redes de múltiplas camadas, reacendendo a abordagem conexionista adormecida desde 1969.
- **1987– — A virada científica e probabilística.** A IA adota metodologia empírica rigorosa e benchmarks. Judea Pearl formaliza as [*redes bayesianas*](https://en.wikipedia.org/wiki/Bayesian_network); difundem-se os modelos ocultos de Markov (HMM) e o aprendizado estatístico. A IA se reconcilia com a estatística, a teoria de controle e a otimização.
- **2001– — A era dos dados.** Percebe-se a "eficácia irracional dos dados": com conjuntos suficientemente grandes, algoritmos simples muitas vezes superam algoritmos sofisticados com poucos dados. Os dados passam a importar tanto quanto os modelos.
- **2011– — Aprendizado profundo (deep learning).** A combinação de GPUs, grandes bases e redes profundas destrava avanços dramáticos. Em **2012**, a rede [AlexNet](https://en.wikipedia.org/wiki/AlexNet) vence a competição ImageNet por larga margem e dispara a revolução do deep learning em visão e fala.

## 6. Do aprendizado profundo aos LLMs

O capítulo 1 do AIMA foi escrito antes do que talvez seja a década mais transformadora da IA. Esta seção estende a história até o presente — é justamente onde a nossa disciplina conecta o clássico ao estado da arte.

- **2012–2016 — a ascensão do profundo.** Redes convolucionais passam a dominar a visão; redes recorrentes (LSTM) e modelos *sequência-a-sequência* avançam tradução e reconhecimento de fala. O aprendizado por reforço profundo aprende a jogar videogames a partir de pixels e, em **2016**, o [*AlphaGo*](https://en.wikipedia.org/wiki/AlphaGo) derrota um dos maiores jogadores humanos de Go — feito então considerado a uma década de distância. A receita — busca em árvore (MCTS) somada a redes profundas e aprendizado por reforço — é um gancho direto para a nossa Unidade 2.
- **2017 — o Transformer.** O artigo [*"Attention Is All You Need"*](https://arxiv.org/abs/1706.03762) introduz a arquitetura **Transformer**, baseada em mecanismos de *atenção*. Ela destrava o treinamento paralelo em escala massiva e se torna o alicerce de quase toda a IA de linguagem que veio depois.
- **2018–2020 — pré-treinamento e escala.** Modelos como BERT e a família GPT popularizam o *pré-treinamento* em grandes corpora seguido de ajuste fino. As [*leis de escala*](https://arxiv.org/abs/2001.08361) mostram que aumentar dados, parâmetros e cálculo melhora o desempenho de forma previsível. O [GPT-3](https://arxiv.org/abs/2005.14165) (2020) exibe *aprendizado com poucos exemplos* — resolver tarefas novas a partir de instruções, sem re-treino.
- **2022 — a IA generativa chega ao público.** O *ajuste por instrução* e o **[aprendizado por reforço a partir de feedback humano](https://arxiv.org/abs/2203.02155)** (RLHF) alinham os modelos ao uso conversacional. O lançamento do ChatGPT leva os modelos de linguagem de larga escala (**LLMs**) ao cotidiano de centenas de milhões de pessoas.
- **2023–2024 — multimodalidade, contexto longo e ciência.** Modelos passam a processar texto, imagem, áudio e vídeo de forma integrada; as *janelas de contexto* crescem de milhares para centenas de milhares e, depois, milhões de tokens. Modelos de *difusão* geram imagens e vídeos de alta qualidade. Na ciência, o [*AlphaFold*](https://en.wikipedia.org/wiki/AlphaFold) prediz estruturas de proteínas com impacto profundo na biologia (reconhecido com o Nobel de Química de 2024).
- **2024–2026 — os modelos de raciocínio.** Surge uma nova classe de modelos que "pensa antes de responder": em vez de produzir a resposta de imediato, o modelo gasta *computação em tempo de inferência* (test-time compute) gerando cadeias de raciocínio, o que eleva o desempenho em matemática, ciência e programação. Benchmarks exigentes — GPQA, FrontierMath, [ARC-AGI-2](https://arcprize.org/), [SWE-bench](https://www.swebench.com/), entre outros — tornam-se a régua do progresso. O cenário fica *multipolar*: vários laboratórios disputam a fronteira com modelos fechados de ponta e modelos *abertos* cada vez mais competitivos, num equilíbrio de especialização e com queda acentuada de custo por token.

> **Nuance — poder não é confiabilidade.** Apesar de impressionantes, esses modelos ainda *alucinam* (afirmam com confiança coisas falsas), falham em planejamento de longo horizonte e não oferecem garantias formais. Reconhecer esses limites é parte da competência técnica — e motiva diretamente a nossa Unidade 5 (incerteza) e a Disciplina 4 (Ética e IA responsável).

## 7. A IA agêntica: o círculo se fecha

A fronteira de 2026 tem um nome: **IA agêntica**. E a boa notícia pedagógica é que ela nos traz de volta, em roupa nova, ao conceito com que abrimos o curso — o agente racional.

<figure>
  <img src="/blog/images/cursos/introducao-ia/agente-ambiente.svg" alt="Laço agente-ambiente: o agente age por atuadores e percebe por sensores, em ciclo." style="width:100%;height:auto">
  <figcaption style="font-size:.85rem;text-align:center;opacity:.7">O laço agente–ambiente (definido na §3.4) — é essa estrutura que a IA agêntica retoma.</figcaption>
</figure>

- **De "chatbot" a "agente".** Um chatbot responde a um *prompt*. Um agente vai além: ele *percebe* um objetivo, *planeja* uma sequência de passos, *usa ferramentas* (chama APIs, executa código, navega na web, opera o computador), *mantém memória* entre etapas e *corrige-se* por realimentação, checando se cada passo aproximou do objetivo. Essa é, quase palavra por palavra, a estrutura do agente que formalizaremos na próxima aula (A2).
- **Os blocos de construção.** Percepção e raciocínio; planejamento; uso de ferramentas; e memória — orquestrados em *laços de execução* que podem rodar de minutos a horas, em vez de uma única troca de mensagens. Surgem *sistemas multiagentes* (vários agentes especializados cooperando) e agentes que controlam diretamente o computador (tirando capturas de tela, movendo o mouse, digitando).
- **A infraestrutura.** Para conectar agentes a ferramentas e a outros agentes, consolidaram-se *protocolos* abertos — por exemplo, um [protocolo de contexto](https://modelcontextprotocol.io/) para a comunicação agente–ferramenta e protocolos de comunicação agente–agente —, comparados por analistas ao papel do "USB-C e do TCP/IP" na era da IA.
- **Os novos problemas.** Quando um agente age com autonomia sobre sistemas reais, surgem questões que um chatbot não levanta: confiabilidade, permissões e identidade (agentes tendem a ficar "superautorizados"), auditoria de cada ação, custo e responsabilização. A *governança de agentes* torna-se tema central — e reforça a importância da ética e da segurança.

> **Conexão com o curso.** A IA agêntica é a versão moderna, movida a LLM, do *agente racional* clássico. E tudo o que estudaremos reaparece dentro dela: **busca** (planejar sequências de ações), **lógica e conhecimento** (representar o mundo e o objetivo), **incerteza** (decidir com informação incompleta) e **decisão/MDPs** (escolher a próxima ação para maximizar o resultado esperado). É por isso que mantemos esses fundamentos "clássicos": eles voltaram ao centro do palco.

## 8. O estado da arte, com honestidade

Uma leitura madura do estado da arte separa o que a IA já faz bem do que ainda é difícil.

### O que a IA faz bem hoje

Linguagem (tradução, redação, resumo, geração de código); visão (reconhecimento e geração de imagens); jogos (desempenho sobre-humano em xadrez, Go, pôquer e diversos videogames); ciência (predição de estruturas de proteínas); diálogo e assistência de propósito geral; e, cada vez mais, a *automação de fluxos de trabalho* por agentes que executam tarefas de várias etapas.

### O que ainda é difícil

Raciocínio robusto e *verificável*; planejamento confiável de longo horizonte; fidelidade factual (evitar alucinações); raciocínio *causal* (distinguir causa de correlação); aprendizado eficiente a partir de poucos dados; generalização para situações fora da distribuição de treino; e, sobretudo, *segurança e alinhamento* — garantir que sistemas cada vez mais autônomos façam o que pretendemos.

> **Nuance — demonstração ≠ produção.** Um sistema que brilha numa demonstração cuidadosamente escolhida pode falhar quando conectado a um sistema real, com dados ruidosos e casos de borda. A diferença entre o "funciona no slide" e o "funciona às 2h da manhã em produção" é feita de *engenharia*: avaliação honesta, guarda-corpos, monitoramento e humano no laço. Capacidade do modelo e confiabilidade do sistema são coisas distintas.

## 9. IA fraca × IA forte; riscos e o debate

Vale distinguir dois sentidos de "IA". A **IA fraca** pergunta se máquinas podem *agir* como se fossem inteligentes — a posição da engenharia, que é a nossa. A **IA forte** pergunta se máquinas podem *realmente* pensar, ter mente e consciência — uma questão filosófica (ilustrada pelo [argumento do "quarto chinês"](https://plato.stanford.edu/entries/chinese-room/), de John Searle). Para construir sistemas úteis, o que importa é o comportamento; a questão da mente, embora fascinante, não precisa ser resolvida para o trabalho de engenharia.

A meta de sistemas amplamente competentes em muitas tarefas costuma ser chamada de **inteligência artificial geral** (AGI). Independentemente de quão perto se está dela, o aumento de autonomia e capacidade traz riscos concretos que já exigem atenção: viés e discriminação, desinformação em escala, impacto sobre o trabalho, uso malicioso e os desafios de segurança e alinhamento de agentes autônomos.

> **Conexão com o curso.** Estes temas não são um apêndice: são uma disciplina inteira (a Disc. 4 — Ética, IA Responsável e Explicabilidade) e voltam na última aula desta disciplina (A28), quando discutiremos fundamentos filosóficos, segurança e o futuro da IA.

## 10. Síntese e o fio do curso

Recapitulando: definimos IA como a construção de *agentes que agem racionalmente*; vimos os quatro enfoques e por que "agir racionalmente" se tornou o princípio organizador — mensurável, geral e cientificamente tratável; percorremos uma história feita de ciclos de entusiasmo e realismo; e mostramos que a era atual (deep learning → LLMs → agentes) fecha o círculo, trazendo o agente racional de volta ao centro.

Este é o mapa do que vem a seguir, e como cada peça responde à pergunta "como agir de forma inteligente?":

| A partir daqui | O que acrescenta ao agente |
|---|---|
| **A2 — Agentes e ambientes** | Formaliza o próprio conceito de agente racional, medida de desempenho e tipos de ambiente. |
| **U2 — Busca e jogos** | Como o agente *decide o que fazer*: encontrar sequências de ações e jogar contra adversários. |
| **U3 — Conhecimento e lógica** | Como o agente *representa o mundo* e infere novas conclusões. |
| **U4 — Planejamento** | Como montar planos de ação em domínios complexos. |
| **U5 — Incerteza** | Como agir bem com informação incompleta, usando probabilidade. |
| **U6 — Decisão / MDPs** | Como escolher ações para maximizar o resultado esperado — a ponte para o Aprendizado por Reforço. |

**Na próxima aula (A2)**, damos o primeiro passo técnico: definir com precisão o que é um agente, o que significa racionalidade em termos de uma medida de desempenho, e como classificar ambientes (observável ou não, determinístico ou estocástico, e assim por diante). É a fundação sobre a qual todo o resto será construído.

## Termos-chave desta aula

- **Agente racional** — sistema que percebe e age para maximizar o resultado esperado dado o que sabe.
- **Medida de desempenho** — critério externo e objetivo que define o que conta como "agir bem".
- **Teste de Turing** — teste comportamental de inteligência por indistinguibilidade em conversa.
- **Racionalidade limitada** — agir tão bem quanto possível com recursos finitos de tempo e cálculo.
- **Conexionismo** — abordagem baseada em redes de unidades simples (neurônios artificiais).
- **Aprendizado profundo** — redes neurais de muitas camadas treinadas com grandes dados e GPUs.
- **Transformer** — arquitetura baseada em atenção; alicerce dos LLMs modernos.
- **LLM** — modelo de linguagem de larga escala, pré-treinado em grandes corpora.
- **RLHF** — ajuste por reforço a partir de feedback humano, usado para alinhar modelos.
- **Modelo de raciocínio** — modelo que gasta cálculo em tempo de inferência para "pensar" antes de responder.
- **IA agêntica** — sistemas que planejam, usam ferramentas e agem em múltiplos passos com autonomia.
- **IA fraca / forte** — agir *como se* fosse inteligente / *realmente* pensar e ter mente.
- **AGI** — inteligência artificial geral: competência ampla em muitas tarefas.
- **Alinhamento** — garantir que sistemas autônomos façam o que pretendemos que façam.

## Questões de revisão

1. Explique as duas dimensões que geram os quatro enfoques da IA e posicione cada enfoque na matriz.
2. Por que "agir racionalmente" é considerado mais geral do que "pensar racionalmente"? Dê um exemplo de ação racional que não passa por inferência lógica explícita.
3. O que é o Teste de Turing e por que ele não guia a construção da maioria dos sistemas modernos? Use a analogia do voo.
4. Diferencie "solúvel em princípio" de "solúvel na prática". Por que essa distinção é central na IA?
5. O que caracteriza a racionalidade limitada e por que ela é mais realista do que a racionalidade perfeita?
6. Descreva dois dos "invernos" da IA: o que os causou e o que a comunidade aprendeu com eles?
7. Qual foi o papel do Transformer (2017) e do RLHF (2022) na trajetória que levou aos LLMs atuais?
8. Explique, com suas palavras, por que a "IA agêntica" pode ser vista como um reencontro com o conceito clássico de agente racional.
9. Cite duas capacidades em que a IA já é forte e dois problemas em que ainda é fraca, justificando.
10. Por que "funcionar numa demonstração" não é o mesmo que "ser confiável em produção"?

## Para ir além (leitura)

- **Base:** Russell & Norvig, [*Inteligência Artificial* (AIMA)](http://aima.cs.berkeley.edu/), cap. 1 — "Introdução".
- **Clássico fundador:** A. M. Turing, ["Computing Machinery and Intelligence"](https://doi.org/10.1093/mind/LIX.236.433) (*Mind*, 1950) — a origem do Teste de Turing.
- **Leituras de ponta:** Yao et al., [*ReAct: Synergizing Reasoning and Acting in Language Models*](https://arxiv.org/abs/2210.03629) (ICLR 2023); Wang et al., [*A Survey on LLM-based Autonomous Agents*](https://arxiv.org/abs/2308.11432) (2024) — como a arquitetura clássica de agentes reaparece nos agentes de LLM.

---

*O conteúdo dos §1–§5 e §9–§10 apoia-se na estrutura conceitual do cap. 1 do AIMA (Russell & Norvig); os §6–§8 estendem o panorama até o estado da arte de meados de 2026 (aprendizado profundo, LLMs, modelos de raciocínio e IA agêntica). Referências a datas e capacidades recentes refletem o cenário de início a meados de 2026 e devem ser reconferidas, pois a área evolui rapidamente.*
