---
layout: post
title: "Estudando: Capítulo 3 do Sutton & Barto — primeiros passos nos Processos de Markov"
date: 2026-06-29 10:00:00 -0300
categories: [Estudando]
tags: [aprendizado-por-reforco, mdp, fundamentos, iniciantes, estudos]
description: "Anotações pessoais da leitura do capítulo 3 do livro do Sutton & Barto, onde aprendi o que é um Processo de Decisão de Markov — e por que ele é a língua oficial do aprendizado por reforço."
---

Resolvi começar a estudar aprendizado por reforço pela fonte que todo mundo recomenda: o *Reinforcement Learning: An Introduction*, do Sutton e do Barto. A boa notícia é que os próprios autores deixam o livro disponível de graça, em PDF — dá pra ler [aqui](http://incompleteideas.net/book/the-book-2nd.html).

Esse post não é um resumo formal nem um tutorial. São minhas anotações depois de penar um pouco no capítulo 3 — *Finite Markov Decision Processes*. Resolvi escrever porque, no meio da leitura, caiu uma ficha que mudou a forma como eu enxergo o assunto. E escrever sobre o que estudo é o jeito que eu encontrei de checar se realmente entendi.

## Onde eu travei no começo

Confesso que abri o capítulo esperando equações e travei já no nome. "Processo de Decisão de Markov" soa como uma daquelas coisas que existem só pra assustar iniciante. Mas o livro abre com uma figura simples — um agente e um ambiente trocando setas — e foi aí que começou a fazer sentido.

A imagem que o capítulo usa é basicamente um ciclo que se repete:

- O ambiente mostra ao agente a situação atual.
- O agente escolhe uma ação.
- O ambiente responde com uma recompensa e uma nova situação.
- E recomeça, indefinidamente.

Quando li isso, a primeira coisa que me veio à cabeça não foi um robô. Foi eu dirigindo por um bairro desconhecido — e, pra piorar, com o celular sem bateria, então sem GPS pra me salvar.

## A cena que me destravou: perdido num bairro, sem GPS

Pensa comigo. Você está num bairro que não conhece, sem GPS, decidindo tudo no olho. Chega num cruzamento, olha a situação, decide virar à direita. Alguns metros depois, outro cruzamento, outra decisão. Às vezes você pega um congestionamento e se arrepende; às vezes emenda três sinais verdes e se sente um gênio.

Sem GPS é importante: ninguém te entrega o caminho pronto. Você só tem o que enxerga agora e precisa decidir com isso. (Esse detalhe vai voltar a importar daqui a pouco.)

Foi assim que o vocabulário do capítulo encaixou pra mim:

Quem decide é o **agente** — eu, ao volante. Tudo que responde às minhas decisões e eu não controlo é o **ambiente** — o bairro, o trânsito, os sinais. A foto da situação ("esquina da Central, sinal vermelho, trânsito leve") é o **estado**. A decisão de virar ou seguir é a **ação**. E o resultado que o mundo me devolve a cada passo — ganhar ou perder tempo — é a **recompensa**.

O capítulo inteiro gira em torno desse loop: o agente decide, o ambiente responde com estado e recompensa, e tudo recomeça.

Parece óbvio depois que você lê. Mas a graça é perceber que dá pra descrever quase qualquer decisão que se repete no tempo dentro dessa mesma estrutura.

## O "Markov" finalmente fez sentido

Essa parte foi a que mais me deixou de cabeça quente antes de cair a ficha.

A **propriedade de Markov** diz que o estado atual já carrega tudo o que importa pra decidir o futuro — o histórico de como você chegou ali não importa.

Eu tentei brigar com isso no começo ("como assim o passado não importa?"), até voltar pro bairro sem GPS. Pra decidir se viro à direita neste cruzamento, o que conta é a situação de agora: o sinal, os carros à frente, pra onde eu quero ir. Não faz diferença se cheguei nessa esquina pela avenida ou cortando por trás. A foto do presente basta — e é justamente por isso que dá pra se virar sem o caminho inteiro na mão.

> Markov é isso: se você sabe onde está, não precisa lembrar de todo o caminho que te trouxe até aqui.

O livro usa o xadrez pra ilustrar algo parecido — a posição atual das peças no tabuleiro já diz tudo, você não precisa da ordem dos lances. Mesmo princípio.

## O erro que eu estava cometendo sozinho

Aqui foi a virada de chave do capítulo pra mim.

Eu vinha pensando que o objetivo do agente era pegar a maior recompensa do próximo passo. Errado. O objetivo é maximizar a soma das recompensas ao longo do caminho inteiro — o que o livro chama de **retorno**.

E essas duas coisas vivem brigando:

- **Recompensa:** o que você ganha AGORA, neste passo.
- **Retorno:** a soma de tudo que você vai ganhar daqui pra frente.

A rua que parece mais rápida agora pode te jogar num beco engarrafado dois quarteirões depois. Quem decide olhando só pro próximo passo é o motorista afobado que troca de faixa toda hora e não chega antes de ninguém. O agente esperto aceita um custo pequeno agora se isso melhora o resultado lá no fim.

O livro ainda introduz um **fator de desconto** aqui: recompensas mais distantes valem um pouco menos que as imediatas. Pensei nisso como "ganhar tempo agora vale mais do que a promessa de ganhar tempo daqui a meia hora" — sem ignorar o futuro, só dando um peso menor pra ele.

## Política e valor: as duas últimas peças

O capítulo fecha apresentando dois conceitos que, juntos, completam o quebra-cabeça.

A **política** é a estratégia do agente: a regra que, dado um estado, diz qual ação tomar. Aprender, num MDP, é descobrir a melhor política possível.

E o **valor** é como o agente avalia uma situação: "estando aqui e seguindo minha estratégia, quanta recompensa total eu espero juntar daqui pra frente?". Foi aqui que separei de vez duas ideias que eu misturava:

> Recompensa é o prazer imediato. Valor é a aposta sobre o futuro.

Uma esquina pode dar recompensa zero agora, mas ter valor alto por ser a entrada do caminho livre até o destino. O agente bom não persegue recompensa — persegue valor.

## O que eu levo desse capítulo

Fechando o capítulo 3, o que ficou pra mim é que um MDP é só quatro coisas: estados, ações, uma dinâmica (o que tende a acontecer depois de cada ação) e um sinal de recompensa. Junte a isso a propriedade de Markov e você tem a estrutura pra descrever quase qualquer problema de decisão que se repete no tempo.

Por isso dizem que MDP é a "língua oficial" do aprendizado por reforço: antes de ensinar uma máquina a aprender, você precisa traduzir o problema pra essa língua — quem é o agente, o que ele observa, o que pode fazer e o que conta como recompensa. Se você também está começando, recomendo ler o capítulo na fonte: o livro está disponível [gratuitamente em PDF](http://incompleteideas.net/book/the-book-2nd.html). O próximo passo da minha lista é entender a tal equação de Bellman, que é onde essa ideia de valor vira conta de verdade. Quando eu penar nela, escrevo por aqui também.

zd4▮
