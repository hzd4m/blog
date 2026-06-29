---
layout: post
title: "Codificador da UESPI: modelando um problema autoral de strings e resolvendo em C++"
date: 2026-06-29 11:00:00 -0300
categories: [Tecnologia]
tags: [competitive-programming, cpp, strings, modelagem, estudos]
description: "Criei um problema de manipulação de strings inspirado no clássico 71A do Codeforces. Aqui mostro a modelagem por trás dele e a resolução em C++ passo a passo."
---

Criei o "Luan e o Codificador da UESPI" como uma variação autoral do clássico *A. Way Too Long Words* (71A) do Codeforces — peguei a base de abreviar palavras longas e adicionei uma camada de cifra pra forçar mais atenção com strings. O enunciado completo está no `questao.md` e a resolução no `main.cpp`.

Quero ir direto ao ponto: primeiro a modelagem, depois o código.

## A modelagem

Pra cada palavra recebida, o resultado depende de duas perguntas — e as duas se baseiam no tamanho da palavra original:

1. tamanho original > 10  ?  -> abrevia : mantém
2. tamanho original é par ?  -> cifra   : inverte

**Abreviação:** primeira letra + quantidade de letras do meio + última letra. O "meio" é `tamanho - 2` (descontando primeira e última). Assim `localization` (12) vira `l10n`.

**Cifra (tamanho par):** cada letra anda uma posição no alfabeto, `z` volta pro `a`. Números não mudam.

**Inversão (tamanho ímpar):** o resultado é simplesmente lido de trás pra frente.

O detalhe que define o problema — e que eu coloquei de propósito — é que toda decisão usa o tamanho **ORIGINAL**, nunca o da string já transformada. Se alguém abreviar primeiro e depois checar a paridade no resultado, erra: `localization` tem 12 (par), mas `l10n` tem 4. Modelar bem aqui significa congelar o tamanho original antes de tocar na string.

## O passo a passo do código

A estrutura do `main` segue a modelagem na mesma ordem. Primeiro, o congelamento do tamanho:

```cpp
int tamanho_original = s.size();
string temp = "";
```

A partir daqui, `tamanho_original` é a única fonte de verdade — nada consulta `temp.size()`.

**Passo 1 — abreviar ou manter:**

```cpp
if (tamanho_original > 10) {
    temp += s[0];
    temp += to_string(tamanho_original - 2);
    temp += s[tamanho_original - 1];
} else {
    temp = s;
}
```

O `to_string(tamanho_original - 2)` transforma o número de letras do meio em texto pra poder concatenar. O `s[tamanho_original - 1]` pega a última letra (índice base zero). Palavra curta cai no `else` e segue inteira.

**Passo 2 — cifrar ou inverter, pela paridade do original:**

```cpp
if (tamanho_original % 2 == 0) {
    temp = cifra(temp);
} else {
    reverse(temp.begin(), temp.end());
}
```

A inversão usa o `reverse` da biblioteca padrão. A cifra ficou numa função à parte:

```cpp
string cifra(string s) {
    for (char &c : s) {
        if (c >= 'a' && c <= 'z') {
            if (c == 'z') {
                c = 'a';
            } else {
                c++;
            }
        }
    }
    return s;
}
```

Três cuidados que vêm direto da modelagem: o `char &c` (referência) altera a string no lugar; o `if (c >= 'a' && c <= 'z')` garante que só letras mudem, deixando os dígitos da abreviação intactos (o `10` de `l10n` continua `10`); e o `z` é tratado à mão pro wrap-around não estourar o alfabeto.

## Conferindo com dois casos

Um par e um ímpar fecham a verificação mental:

```
localization (12, par)
  abrevia -> l10n
  cifra   -> m10o

algoritmo (9, ímpar)
  não abrevia -> algoritmo
  inverte     -> omtirogla
```

Ambos batem com a saída esperada do enunciado.

## Uma nota de limpeza

Deixei no arquivo uma função `verificapar` que não chego a usar — fiz a checagem de paridade inline com `% 2 == 0`. Funciona, mas é código morto; numa revisão, ou passo a usá-la, ou removo.

## Complexidade

Cada palavra é percorrida um número constante de vezes:

```
Tempo:   O(n * L)
Memória: O(L)
```

Com `n ≤ 100` e `L ≤ 100`, passa folgado. O desafio aqui nunca foi performance — foi modelar a separação entre o dado original e o resultado intermediário. Quando essa fronteira fica clara na cabeça, o código praticamente se escreve sozinho.

O enunciado está no `questao.md` e a solução completa no `main.cpp`. Fica o convite: tente modelar antes de olhar a resolução.

zd4▮
