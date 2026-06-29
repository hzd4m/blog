---
layout: post
title: "Resolvendo: Queue at the School (266B)"
date: 2026-06-29 13:00:00 -0300
categories: [Resolvendo]
tags: [competitive-programming, cpp, simulacao, modelagem, estudos]
description: "Um problema de simulação do Codeforces, onde o segredo não é uma fórmula esperta e sim respeitar a simultaneidade das trocas. Modelagem e resolução em C++ passo a passo."
---

Dessa vez peguei um problema original: o [*Queue at the School* (266B)](https://codeforces.com/problemset/problem/266/B) do Codeforces. É um problema de simulação — daqueles em que você não precisa de uma fórmula esperta, só precisa reproduzir fielmente o que o enunciado descreve, passo a passo. Minha resolução está no [`main.cpp`](https://github.com/hzd4m/algoritmos/blob/main/uespi/semana_1/266B-QueueAtTheSchool/main.cpp).

Modelagem primeiro, código depois.

## A modelagem

A fila é uma string de `B` (boys) e `G` (girls). A cada segundo, a regra é: sempre que um menino estiver logo na frente de uma menina (`BG`), eles trocam de lugar — o menino deixa a menina passar, virando `GB`. Isso acontece com todos os pares ao mesmo tempo. Repetimos por `t` segundos e imprimimos a fila final.

Aqui mora a única armadilha de verdade do problema: como as trocas de um segundo são simultâneas, depois de trocar um par `BG` em `GB`, eu não posso reavaliar o menino que acabou de andar pra trás dentro do mesmo segundo. Se eu fizesse isso, ele poderia trocar de novo na mesma rodada, e a simulação ficaria errada (avançaria rápido demais).

A modelagem que resolve isso é: ao trocar um par na posição `i`, pulo direto para `i + 2`. Assim o caractere que acabou de chegar na posição `i + 1` não é olhado de novo neste segundo.

## O passo a passo do código

Começa com a leitura: `n` (tamanho), `t` (segundos) e a string da fila:

```cpp
int n, t;
cin >> n >> t;
string s;
cin >> s;
```

O laço externo é o tempo — uma iteração por segundo:

```cpp
for (int segundos = 0; segundos < t; segundos++) {
    int i = 0;
    ...
}
```

E o laço interno varre a fila uma vez, da esquerda pra direita, aplicando a regra:

```cpp
while (i < n - 1) {
    if (s[i] == 'B' && s[i + 1] == 'G') {
        swap(s[i], s[i + 1]);
        i += 2;
    } else {
        i++;
    }
}
```

Repara nos detalhes que vêm direto da modelagem. O `i < n - 1` garante que eu sempre tenho um vizinho `s[i + 1]` válido pra comparar (não estouro o fim da string). Quando acho um par `BG`, o `swap` faz a troca e o `i += 2` é a peça-chave: ele salta o par inteiro, impedindo que o menino recém-movido seja reavaliado neste mesmo segundo. Quando não é um par `BG`, eu só avanço uma posição com `i++`.

Por que `while` com `i` controlado à mão, e não um `for` simples? Justamente por causa do `i += 2`. Eu preciso decidir, caso a caso, se ando uma ou duas posições — e o `while` me dá esse controle do passo.

No fim de todos os segundos, imprimo a fila:

```cpp
cout << s << "\n";
```

(Detalhe de limpeza: ficou um `return 0;` duplicado no final do arquivo — o segundo é código morto, inalcançável. Não atrapalha, mas numa revisão eu removo.)

## Conferindo com um caso

Pega `BGGB` com `t = 1`:

```
posição:  0123
inicial:  BGGB
i=0: s[0]=B, s[1]=G -> troca -> GBGB, i=2
i=2: s[2]=G          -> não é BG -> i=3
i=3: para (i < n-1 falso)
final do segundo 1:  GBGB
```

Só um par trocou neste segundo, mesmo havendo outro `BG` mais à frente que "nasceu" depois — exatamente o comportamento simultâneo que o `i += 2` protege. Se rodasse mais um segundo, o `GB` do meio viraria a vez do próximo par.

## Complexidade

O laço externo roda `t` vezes e o interno percorre a fila inteira (`n`):

```
Tempo:   O(n * t)
Memória: O(n)
```

Com os limites pequenos do problema (`n, t ≤ 50`), isso é instantâneo. Simulação direta é mais que suficiente aqui — não precisa de truque.

O aprendizado que levo: em problemas de simulação, o erro raramente está no algoritmo e quase sempre está em respeitar a simultaneidade do enunciado. O `i += 2` é pequeno, mas é ele que separa a resposta certa de uma fila que "anda rápido demais".

Resolução completa no [`main.cpp`](https://github.com/hzd4m/algoritmos/blob/main/uespi/semana_1/266B-QueueAtTheSchool/main.cpp), e o problema original no [Codeforces 266B](https://codeforces.com/problemset/problem/266/B).

zd4▮
