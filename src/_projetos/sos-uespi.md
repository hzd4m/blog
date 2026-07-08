---
layout: projeto
title: "SOS UESPI — Chamados de manutenção do campus"
slug: sos-uespi
ordem: 2
ano: 2026
tech: [Ruby on Rails, Hotwire, PostgreSQL, Tailwind CSS, PWA]
subtitulo: "PWA em Rails para registrar, acompanhar e resolver problemas físicos do campus da UESPI em Teresina."
descricao: "Sistema de chamados em Ruby on Rails 8 para a UESPI: qualquer pessoa do campus reporta um problema físico com foto e localização, e a gestão acompanha tudo com fila priorizada, SLA e mapa."
---

Todo campus tem aquilo: a lâmpada queimada que ninguém sabe pra quem avisar, o bebedouro parado há semanas, a tomada solta na sala de aula. O **SOS UESPI** existe pra isso — é um sistema de chamados onde qualquer pessoa da comunidade do campus da UESPI em Teresina registra um problema físico, com foto e localização, e a gestão consegue acompanhar tudo até a resolução.

É um app **Ruby on Rails 8** de ponta a ponta: server-rendered com Hotwire (Turbo + Stimulus), PostgreSQL, Tailwind e quase nada de JavaScript próprio. Também é um **PWA** — instala no celular, tem fallback offline e push notification opcional via Web Push (VAPID).

## O que tem dentro

- **Chamados com ciclo de vida** — cada chamado nasce com protocolo, descrição, categoria, ponto do campus e foto opcional, e passa por uma máquina de estados: enviado → em análise → em andamento → resolvido (e pode ser reaberto).
- **Fila priorizada com SLA** — prioridade alta, média ou baixa define um prazo (24h, 72h ou 120h), e o sistema sinaliza chamados próximos do vencimento e vencidos.
- **Mapa do campus** — os pontos do campus têm coordenadas, e um mapa Leaflet sobre OpenStreetMap mostra os chamados abertos como pinos coloridos por prioridade.
- **Setores responsáveis** — chamados podem ser encaminhados pra setores (com membros participantes), com comentários internos e uma linha do tempo de eventos.
- **Papéis e aprovação de cadastro** — admin geral, admin, representante e membro; o auto-cadastro exige e-mail institucional e passa por aprovação, e também dá pra entrar por convite.
- **Painel, indicadores e relatórios** — visão de gestão sobre o volume e a situação dos chamados.
- **Organograma institucional** — campi, centros, cursos, turmas e vínculos institucionais dos usuários.
- **Privacidade** — termos de uso com aceite registrado, política de privacidade e um fluxo de solicitações de privacidade (pensando em LGPD), além de trilha de auditoria.

## Decisões técnicas

A stack é o "omakase" do Rails 8 levado a sério: **Solid Queue, Solid Cache e Solid Cable** rodando em cima do próprio Postgres, sem Redis; importmaps em vez de bundler de JS; autenticação feita na mão com `has_secure_password` e sessões próprias, sem Devise; autorização com **Pundit**. Deploy pensado pra container com Kamal.

O mapa é o único lugar com JavaScript de verdade: um controller Stimulus que recebe os chamados como JSON e desenha os pinos no Leaflet — o resto da interface é HTML renderizado no servidor com Turbo por cima.

O service worker do PWA é deliberadamente conservador: cacheia só assets seguros e serve um fallback offline neutro, sem nunca cachear páginas autenticadas com chamados, notificações ou sessão. Criação offline de chamados ficou de fora de propósito — melhor um offline honesto e pequeno do que um cache que vaza dado.
