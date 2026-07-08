---
layout: post
published: false
title: "O que é BKT — e como ele virou o cérebro do MedCortex One"
date: 2026-07-08 00:30:00 -0300
categories: [Tecnologia]
tags: [bkt, ia, educacao, aprendizado-adaptativo, medcortex]
description: "Uma explicação básica de Bayesian Knowledge Tracing — a técnica que estou usando no MedCortex One pra estimar, a cada resposta, o quanto o aluno realmente domina cada assunto."
---

Estou construindo o MedCortex One, um app de estudo adaptativo pra Medicina. A ideia é simples de falar e difícil de fazer: o app precisa saber o que o aluno já domina e o que ainda não, pra decidir o que mostrar em seguida. E foi correndo atrás disso que eu esbarrei numa técnica com nome pomposo e ideia surpreendentemente simples: **BKT — Bayesian Knowledge Tracing**.

Esse post é a versão básica da história. Sem fórmula, sem derivação — só a intuição que eu gostaria de ter lido antes de começar. A matemática e a implementação ficam pra um próximo post.

## O problema: acertar não é saber

A primeira tentação de quem constrói um app de questões é medir conhecimento na régua mais óbvia: porcentagem de acerto. Acertou 8 de 10? Sabe 80%. Pronto.

Só que isso quebra rápido, e quebra dos dois lados.

De um lado, tem o aluno que **acerta chutando**. Numa questão de múltipla escolha com 4 alternativas, qualquer pessoa acerta 1 em cada 4 sem saber absolutamente nada. Do outro, tem o aluno que **erra sabendo** — bateu o olho errado, confundiu duas opções parecidas, clicou sem querer. Todo mundo que já fez prova conhece os dois cenários.

Ou seja: a resposta que eu observo (acertou/errou) não é a mesma coisa que o estado que eu quero conhecer (domina/não domina). Uma é o sinal visível; a outra é a coisa escondida por trás. E é exatamente pra esse tipo de problema — inferir algo escondido a partir de sinais ruidosos — que existe raciocínio bayesiano.

## A ideia do BKT em uma frase

O BKT trata o domínio de uma habilidade como uma **crença em forma de probabilidade**, e vai atualizando essa crença a cada resposta do aluno.

Em vez de dizer "o aluno sabe insuficiência cardíaca: sim ou não", o sistema mantém algo como "estou 62% convencido de que o aluno domina insuficiência cardíaca". Aí o aluno responde uma questão sobre o assunto e o sistema refaz a conta:

- Acertou? A crença sobe. Mas sobe **pouco** se a questão era fácil de chutar, e sobe mais se era do tipo que só acerta quem sabe.
- Errou? A crença desce. Mas desce **menos** do que você imagina, porque o sistema sabe que gente que domina também escorrega de vez em quando.

E tem um detalhe bonito: além de atualizar a crença com base na resposta, o BKT também assume que **responder é uma oportunidade de aprender**. Cada questão que o aluno encara tem uma chance de fazer a ficha cair. Então a estimativa de domínio tende a subir ao longo da prática — que é exatamente o que a gente espera de alguém estudando.

O resultado é uma trajetória: a probabilidade de domínio começa num palpite inicial e vai sendo refinada resposta após resposta, como um velocímetro do aprendizado que se ajusta em tempo real.

## As quatro perguntas por trás do modelo

Pra fazer essa conta, o BKT clássico precisa de quatro parâmetros. Não vou entrar na matemática, mas vale conhecer as perguntas que cada um responde, porque elas são muito humanas:

- **Chance de já saber** (`p_l0`): qual a probabilidade de o aluno já dominar o assunto antes mesmo da primeira questão? Ninguém chega zerado.
- **Chance de aprender** (`p_t`): a cada questão respondida, qual a probabilidade de o aluno passar de "não domina" pra "domina"?
- **Chance de escorregar** (`p_s`, o famoso *slip*): qual a probabilidade de errar uma questão mesmo dominando o assunto?
- **Chance de chutar certo** (`p_g`, o *guess*): qual a probabilidade de acertar sem dominar nada?

São esses dois últimos que resolvem o problema lá do começo. O *guess* impede que o sistema se empolgue com acertos baratos, e o *slip* impede que ele condene o aluno por um tropeço. Juntos, eles são o que separa o BKT de uma porcentagem de acerto ingênua.

## Como isso aparece no MedCortex One

No MedCortex One, cada assunto da taxonomia tem seu próprio estado BKT por aluno. O motor é pequeno — na prática são dois serviços: um que atualiza a crença depois de cada resposta e outro que calcula o domínio pra decidir o que vem a seguir.

Um exemplo concreto de como os parâmetros mudam a leitura do mesmo evento: o app tem questões de múltipla escolha e flashcards. Na múltipla escolha de 4 alternativas, a chance de chutar certo é enorme — 1 em 4. No flashcard, que exige que você **evoque** a resposta da própria cabeça, chutar certo é quase impossível. Então um acerto em flashcard vale muito mais como evidência de domínio do que um acerto em múltipla escolha — e o BKT captura isso naturalmente, só de dar valores diferentes de *guess* pra cada tipo.

Isso, pra mim, foi a parte mais satisfatória de implementar: o modelo formaliza uma intuição que todo estudante de Medicina já tem. Acertar uma questão de prova reconhecendo a alternativa certa é uma coisa; lembrar a resposta do nada é outra bem diferente.

## Sendo honesto sobre os limites

Não quero vender isso como mágica. Os parâmetros que estou usando hoje vêm da literatura (o trabalho clássico é o de Corbett & Anderson, de 1994) — são valores de arranque, provisórios, que ainda precisam ser calibrados com dados reais dos alunos. E o BKT clássico tem simplificações conhecidas: assume que domínio, uma vez adquirido, não se perde (quem estuda pra prova sabe que esquecer existe), e trata cada habilidade de forma isolada.

Mas mesmo nessa versão básica, ele já é um salto absurdo em relação a "porcentagem de acerto". Sai um número que mente e entra uma crença que aprende.

## O que vem depois

Esse foi o post-intuição, de propósito. Num próximo, quero descer um degrau: mostrar a atualização bayesiana de verdade, o passo a passo da conta que acontece a cada resposta no MedCortex One, e as decisões de implementação — incluindo as que ainda me deixam com a pulga atrás da orelha. Quando eu penar nelas o suficiente pra escrever com honestidade, aparece por aqui.

zd4▮
