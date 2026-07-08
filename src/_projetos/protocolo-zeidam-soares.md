---
layout: projeto
title: "Protocolo Zeidam-Soares — Análise Interativa de Algoritmos de Ordenação"
slug: protocolo-zeidam-soares
ordem: 5
ano: 2026
tech: [Web, JavaScript, Web Audio API, Google Gemini API, C++]
subtitulo: "Plataforma educacional que transforma a análise de algoritmos de ordenação numa experiência visual, sonora e interativa."
descricao: "Mini plataforma web para ensino de algoritmos de ordenação: visualização passo a passo de 6 algoritmos, corrida O(n²) vs O(n log n), tutor com Gemini, sonificação de dados e quizzes."
capa: /images/projetos/protocolo-zeidam-soares/01_visualizacao.png
galeria:
  - src: /images/projetos/protocolo-zeidam-soares/01_visualizacao.png
    legenda: "Jornada dos Algoritmos — visualização passo a passo do Bubble Sort, com inspeção das variáveis de memória e complexidades de melhor, médio e pior caso"
  - src: /images/projetos/protocolo-zeidam-soares/02_codigo_fonte.png
    legenda: "Código Fonte — animação do Merge Sort lado a lado com a implementação em C++, com anotações de custo espacial e variáveis de iteração"
  - src: /images/projetos/protocolo-zeidam-soares/03_benchmark.png
    legenda: "Resultados — bateria de testes em C++ com tempo e comparações para N=1000, 10000 e 50000, incluindo o caso crítico inversamente ordenado"
---

Uma mini plataforma educacional pra ensinar e analisar **algoritmos de ordenação**. A ideia é tirar o Big O do quadro-negro: em vez de aceitar que O(n log n) é melhor que O(n²), você **vê**, **ouve** e mexe na lógica de ordenação rodando em tempo real — tudo embalado numa estética Sci-Fi de tema escuro, meio "console de nave".

O nome vem dos sobrenomes dos autores do estudo que deu origem a tudo: o projeto nasceu de um trabalho de análise comparativa de algoritmos de ordenação em C++ (implementações eficientes e não-eficientes), e a plataforma é a versão interativa dessa análise.

## O que tem dentro

- **Visualização Neural** — renderização passo a passo de 6 algoritmos (Bubble, Selection, Insertion, Merge, Heap, Quick), com inspeção das variáveis de memória a cada iteração e legenda do que o algoritmo está fazendo naquele exato passo.
- **Grande Prêmio dos Algoritmos** — modo corrida: os algoritmos disputam no mesmo array e a disparidade entre O(n²) e O(n log n) fica escancarada em cenários de estresse.
- **Tutor IA integrado** — chatbot educacional com a **Google Gemini API**, que explica trechos do código C++ e responde dúvidas no contexto do que está na tela.
- **Sonificação de dados** — um motor de áudio com **Web Audio API** gera frequências a partir dos valores do array. Dá literalmente pra *ouvir* a eficiência: o Quick Sort soa diferente do Bubble Sort.
- **Gamificação** — quizzes visuais e desafios de código sobre invariantes de laço e estabilidade.

## Nota técnica

Por trás da interface tem uma bateria de benchmarks em **C++** medindo tempo e número de comparações para N = 1.000, 10.000 e 50.000, mais o caso crítico de array inversamente ordenado. Os números são eloquentes: com 50 mil elementos, o Bubble Sort leva ~15 segundos onde o Quick Sort resolve em ~12 milissegundos. É essa distância que a plataforma tenta fazer o aluno sentir — na tela e no ouvido.
