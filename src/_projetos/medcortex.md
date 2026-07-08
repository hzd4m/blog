---
layout: projeto
title: "MedCortex — estudo adaptativo para Medicina"
slug: medcortex
ordem: 3
ano: 2026
tech: [Ruby on Rails, PostgreSQL, Hotwire, Solid Queue, BKT, Grafo de competências]
subtitulo: "Plataforma de estudo para estudantes de Medicina: banco de questões, simulados, flashcards com revisão espaçada e uma estimativa honesta do que o aluno domina."
descricao: "App Rails de educação médica adaptativa: BKT para estimar domínio por competência, taxonomia hierárquica de ~300 nós e um grafo de pré-requisitos em construção."
---

O **MedCortex** é uma plataforma de estudo para estudantes de Medicina que estou construindo em Rails. A ideia base é simples: banco de questões, simulados, flashcards e revisão espaçada — o arroz com feijão de qualquer app de estudo. A parte que me interessa de verdade é a camada por baixo: o sistema tenta **estimar o quanto o aluno domina cada competência** e usar isso a favor dele. O projeto nasceu de pesquisa (PIBIC, UESPI), mas é pensado como produto: a pesquisa é a origem, não a missão.

Está em desenvolvimento — MVP, sem usuários reais ainda. O que descrevo abaixo é o que existe no código hoje, sem promessa do que vai existir amanhã.

## O que tem dentro

- **Banco de questões e simulados** — questões de múltipla escolha organizadas numa taxonomia médica (Clínica Médica, Cirurgia, Pediatria, GO, Preventiva, Ciclo Básico), com simulados cronometrados.
- **Flashcards com revisão espaçada** — agendamento pelo algoritmo FSRS-6, com log imutável de revisões.
- **Estimativa de domínio por competência** — via BKT, que é o assunto da próxima seção.

Stack: Ruby 3.4, Rails 8.1, PostgreSQL, Hotwire (Turbo + Stimulus), Solid Queue para jobs (sem Redis), Pundit para autorização.

## BKT: estimando o que o aluno domina

A pergunta que a revisão espaçada responde é "*quando* rever este item". A que ela não responde é "*quanto* o aluno domina esta competência". Para essa segunda, uso **BKT (Bayesian Knowledge Tracing)** — um modelo clássico (Corbett & Anderson, 1994) que trata o domínio de uma habilidade como uma probabilidade que vai sendo atualizada a cada resposta do aluno.

O modelo tem quatro parâmetros:

- **P(L₀)** — probabilidade de o aluno já dominar a competência antes de qualquer observação (aqui, 0.35);
- **P(T)** — probabilidade de *aprender* a cada oportunidade de prática (0.10);
- **P(S)** — *slip*: errar mesmo dominando (0.10);
- **P(G)** — *guess*: acertar sem dominar.

A cada resposta, o sistema faz dois passos: um passo de **inferência bayesiana** (dado que acertou ou errou, qual a nova crença de que domina?) e um passo de **transição** (mesmo que não dominasse, pode ter aprendido agora). O resultado é um `P(domina)` entre 0 e 1 por aluno × competência.

Um detalhe que considero importante: **P(G) não é um valor só**. Numa questão de múltipla escolha com 4 alternativas, dá pra acertar no chute — P(G) ≈ 0.25, derivado do número real de alternativas do banco, não chutado. Num flashcard de evocação livre, não há chute — P(G) ≈ 0.02. Se o modelo usasse o mesmo *guess* para os dois, sobrestimaria o domínio em questões de múltipla escolha. Então a tabela de parâmetros tem `p_g_mcq` e `p_g_flashcard` como colunas separadas, e o motor escolhe pelo tipo da tentativa que está consumindo.

Outra decisão que me importa é a de **apresentação honesta**: `P(domina)` nunca é mostrado como fato ("você sabe 72%"), sempre como estimativa — com o número de observações e a versão dos parâmetros junto. É uma crença estatística, e o produto trata como tal. Os valores dos parâmetros são provisórios, vindos da literatura, aguardando calibração com dados reais.

## Competências em grafo

As competências vivem numa **taxonomia hierárquica** de cerca de 300 nós: área → especialidade → subtema → tópico, uma árvore auto-referente no PostgreSQL (`parent_id`), com invariantes garantidas no banco — trigger que valida o nível, trigger que detecta ciclo, profundidade máxima 8.

O uso mais interessante da estrutura hoje é na **propagação do BKT**: uma resposta num nó-folha ("insuficiência cardíaca", digamos) conta como observação para o nó e para todos os ancestrais — subtema, especialidade, área. Isso é resolvido com uma CTE recursiva no Postgres que sobe a cadeia de `parent_id` de uma vez, em vez de N queries. Assim o painel consegue dizer algo tanto sobre o tópico específico quanto sobre "Clínica Médica" como um todo.

A parte de **arestas de pré-requisito** — competência A destrava competência B — está modelada no schema (tabela `pre_requisitos`, com validação anti-auto-referência), mas deliberadamente **inativa no MVP**: nenhum fluxo lê ou escreve nela ainda. A estrutura existe para que a ativação futura seja aditiva, sem migração destrutiva. O grafo completo está sendo desenvolvido em paralelo, num projeto separado com Neo4j: um piloto em Geriatria com ~226 habilidades classificadas por nível de Bloom e três tipos de aresta (pré-requisito, complementar, integrativa), de onde saem trilhas de aprendizagem — que caminho seguir, o que precisa vir antes do quê. A intenção é que, quando o grafo se conectar ao app, o `P(domina)` do BKT sirva de critério para destravar conteúdo e recomendar o próximo passo. Por enquanto, é isso: árvore ativa no produto, grafo em construção ao lado.

## Uma coisinha de engenharia que gosto

Os parâmetros do BKT vivem numa tabela **versionada e append-only** — e o append-only não é combinado, é imposto pelo banco: um trigger `BEFORE UPDATE OR DELETE` rejeita qualquer alteração com exceção. Recalibrar os parâmetros significa inserir uma **nova versão** (`bkt-lit-v1` → `bkt-em-v1`), nunca editar a existente. Não há coluna `ativo` nem `updated_at`: a versão vigente é *derivada* (a mais recente), porque flipar um flag seria um UPDATE numa linha que nunca deveria mudar.

E cada estimativa persistida carrega, por foreign key, **a versão de parâmetros que a gerou**. Junto com a ordenação determinística das observações no recálculo (timestamp, número da tentativa, id como desempate), isso dá a propriedade que sustenta o resto: a tabela de estimativas é só cache. Dá pra truncar tudo e recalcular do zero a partir do log imutável de tentativas, chegando exatamente no mesmo resultado. As respostas do aluno são fatos; a estimativa é interpretação — e interpretação tem que ser descartável e reproduzível.

## Estado atual

MVP em construção, com uma parte razoável do esforço indo para fundação: autorização default-deny, telemetria com contrato versionado, privacidade desenhada desde o início (apagamento por crypto-shredding). Nada disso aparece na tela, mas é o tipo de coisa que custa caro consertar depois.
