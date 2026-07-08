---
layout: projeto
title: "LabFit — Treino guiado pelo personal"
slug: labfit
ordem: 4
ano: 2026
tech: [Ruby on Rails, Inertia, React, PostgreSQL, Tailwind CSS]
subtitulo: "Web app para personal trainers e seus alunos: o aluno entra por convite, passa por um onboarding e recebe sua semana de treino."
descricao: "App de treino em Rails 8 + Inertia/React: o personal monta a semana do aluno, o aluno registra cargas e check-ins, e uma camada de constância (chama semanal, conquistas, parceiro) segura o hábito."
---

O **LabFit** é um app de treino com dois lados: o **personal** monta e acompanha os treinos, e o **aluno** executa, registra e — a parte que mais me interessou construir — cria constância. Não é um app de treino genérico com biblioteca de exercícios pra você se virar sozinho: aqui o aluno só existe porque um personal o cadastrou.

## O fluxo do aluno

O aluno não faz signup. O personal cadastra o aluno, o sistema gera um **link de convite** com token único, e é por ele que o aluno entra pela primeira vez: define a senha ali mesmo (ele nasce sem senha no banco), passa por um **onboarding** curto de três telas e cai direto na sua **semana de treino** — a tela "Hoje", com o treino do dia, séries, repetições e descanso definidos pelo personal. Esse fluxo inteiro (convite → onboarding → semana) tem um teste de sistema cobrindo de ponta a ponta.

No dia a dia, o aluno marca exercícios como concluídos, registra a carga e fecha o dia com um **check-in** — que ainda coleta RPE e duração do treino. Desse histórico derivam as outras camadas do app.

## A camada de constância

A aposta do produto é que o difícil não é treinar, é **continuar treinando**. Então em volta do core (treino → registro → check-in) existe:

- **Chama semanal** — streak de semanas consecutivas em que o aluno bateu a meta de treinos. A meta vale em quaisquer dias da semana, e a semana corrente nunca quebra antes de domingo acabar.
- **Conquistas** — marcos detectados automaticamente a partir do histórico.
- **Parceiro** — uma criatura única que o aluno monta por peças (corpo, cor, olhos, temperamento) e que evolui de estágio conforme a jornada. Decisão de design importante: o core **nunca** depende do parceiro; ele é recompensa, não pedágio.
- **Patentes com trava de segurança** — o personal define um **platô** (teto seguro de carga) por exercício, e a faixa do aluno sobe por progresso *até* o platô mais consistência. Carga acima do teto não premia — o app se recusa a gamificar imprudência, e ainda avisa o personal quando o aluno estoura o limite.
- **Bodygraph** — mapa de volume por grupo muscular na semana, pro aluno (e pro personal) enxergar desequilíbrio.

Há também métricas corporais, um painel do personal com a visão de cada aluno e um painel do **dono** da operação — que por decisão explícita só enxerga agregados de negócio, nunca nome ou dado pessoal de aluno (LGPD).

## Decisões técnicas

A stack é **Rails 8.1** com **Inertia.js + React 19** e Tailwind, PostgreSQL, e a trinca **Solid Queue / Solid Cache / Solid Cable** — fila, cache e websocket no próprio Postgres, sem Redis na infra. Deploy com Kamal, testes com RSpec (requests + system com Capybara rodando o React de verdade) e Vitest no frontend.

Duas escolhas de modelagem que eu defenderia em qualquer code review:

- **Estado derivado, nunca coluna.** Streak, estágio do parceiro, patente e mapa muscular são POROs que calculam tudo a partir do histórico de check-ins e registros. Não existe coluna `streak_atual` pra dessincronizar — mesmo histórico, mesmo resultado, sempre.
- **Uma tabela de usuários auto-referenciada.** Personal e aluno vivem na mesma tabela com `papel` (string enum) e `personal_id` apontando pra própria tabela. O papel "dono" entrou depois sem migration nenhuma.

Detalhe que me diverte: o domínio inteiro está em português no código — `Treino`, `Checkin`, `Conquista`, `Sequencia`, `AvisoDePlato`. Num projeto solo pra um produto brasileiro, ler `aluno.convite_pendente?` vale mais que a convenção em inglês.
