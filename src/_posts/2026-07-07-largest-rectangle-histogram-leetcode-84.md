---
layout: post
title: "Resolvendo: Largest Rectangle in Histogram (LeetCode 84)"
date: 2026-07-07 19:22:00 -0300
categories: [Resolvendo]
tags: [cpp, stl, competitive-programming, stack]
description: "O problema que me fez apanhar de verdade. Começo mostrando a solução errada que escrevi de primeira, por que ela quebra, e só depois chego na pilha monotônica que resolve tudo em O(N)."
---

Esse é daqueles problemas que separam quem *usa* estrutura de dados de quem *entende* estrutura de dados. O [*Largest Rectangle in Histogram* (LeetCode 84)](https://leetcode.com/problems/largest-rectangle-in-histogram/) parece bobo à primeira vista — um histograma de barras, achar o maior retângulo que cabe dentro dele — e foi justamente por parecer bobo que eu caí de cara.

Vou fazer diferente dos outros posts da série: começo mostrando a solução **errada** que escrevi de primeira. Porque aqui o erro ensina mais que o acerto — ele mostra exatamente qual é a armadilha do problema.

Pra fixar o alvo, esse é o histograma que vou usar o post inteiro (as barras `2 1 5 6 2 3`):

```
6 │       █
5 │     ▓ ▓
4 │     ▓ ▓
3 │     ▓ ▓     █
2 │ █   ▓ ▓ █   █
1 │ █ █ ▓ ▓ █   █
  └───────────────
idx 0 1 2 3 4 5
h   2 1 5 6 2 3
```

O maior retângulo é aquele destacado (`▓`): altura `5` sobre as barras dos índices 2 e 3, largura `2` → área **10**. Repara que ele não usa a barra mais alta inteira (a de altura `6`): pra ganhar largura, teve que se limitar à altura da vizinha. O post inteiro é sobre como chegar nesse `10` sem testar todos os retângulos possíveis.

## Minha primeira tentativa (a que não funcionou)

Minha cabeça foi no caminho mais óbvio: percorrer o histograma da esquerda pra direita, guardando a "menor altura até agora" e multiplicando pela base que ia crescendo. Saiu isso:

```cpp
class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        int maior = heights[0];
        int area;
        int base = 1;
        for (int i = 0; i < n; i++) {
            if (heights[i] < heights[i + 1]) {
                int area_c;
                maior = heights[i];
                base += 1;
                area_c = maior * base;
                area = max(area, area_c);
            } else if (heights[i] > heights[i + 1]) {
                maior = heights[i + 1];
                base += 1;
            }
        }
    }
};
```

A intuição era: mantenho `maior` como a menor altura vista, `base` como a largura acumulada, e vou multiplicando um pelo outro a cada passo comparando a barra atual com a vizinha. Faz até sentido no papel. Mas por mais que eu ajeitasse os detalhes, o resultado nunca batia — e o motivo não estava em nenhuma linha específica. Estava na **ideia** por trás.

## Por que a ideia quebra

O problema é achar que dá pra resolver isso com uma passada linear ingênua, comparando cada barra só com a **vizinha**. Onde isso desaba:

- **Flutuações de altura.** Pega o histograma `2 → 1 → 5 → 6 → 2 → 3`. Quando a altura despenca de `6` pra `2`, o retângulo bonito que as barras `5` e `6` formavam simplesmente *ficou pra trás* — e a minha lógica nunca calculou a área dele.
- **Histórico perdido.** Quando a altura cai pra um valor menor, essa barra baixa consegue se estender pra trás **por cima** de várias barras antigas que eram mais altas que ela. Comparando só com a vizinha, eu não tenho como saber até onde.
- **A saída fácil vira O(N²).** Sem uma forma estruturada de "olhar pra trás", a alternativa é testar todo par início/fim — `O(N²)`, que dá **TLE** com `N = 10^5`.

Ou seja: o erro não foi de digitação. Foi de modelagem. Eu estava fazendo a pergunta errada.

## Fui ver como se resolve: "quem limita o meu retângulo?"

Cansei de bater cabeça. Ajeitei, reescrevi, testei outros casos, e nada — a ideia continuava furada na raiz. Então fiz o que tinha que fazer: fui atrás da solução do problema pra entender de vez como ele se resolve. E não tem vergonha nenhuma nisso. Quando você está aprendendo, ir estudar a solução consagrada é parte do jogo; o que vale é sair de lá *entendendo* de verdade, a ponto de conseguir explicar. É o que eu vou fazer aqui.

A chave que eu não tinha enxergado é que a pergunta estava de cabeça pra baixo. Em vez de pensar em *como o retângulo cresce* barra a barra, a solução vira o problema do avesso e pergunta outra coisa:

> Se a barra atual `i`, de altura `H`, for a barra **mais baixa** do meu retângulo, até onde eu consigo esticá-lo pra esquerda e pra direita?

Um retângulo que usa a barra `i` como gargalo (a altura-limite) só para de crescer quando esbarra em:

- uma barra **menor à esquerda** — o limite esquerdo `L`;
- uma barra **menor à direita** — o limite direito `R`.

Se eu descobrir esses dois limites pra cada barra, a largura é `R - L - 1` e a área é:

```
área = heights[i] * (R - L - 1)
```

A resposta do problema é o maior desses valores considerando cada barra como gargalo.

## A pilha monotônica: achando os limites em O(N)

Pra achar "a primeira barra menor à esquerda" e "a primeira barra menor à direita" sem varrer o array toda vez, eu mantenho uma **pilha de índices** cujas alturas estão sempre em ordem crescente (é isso que "monotônica" quer dizer aqui).

E por que crescente? Porque essa ordenação não é imposta na marra — ela cai de graça da própria regra. Eu só empilho uma barra quando ela é maior ou igual ao topo; e quando aparece uma menor, eu removo do topo todo mundo que é mais alto que ela antes de empilhar. O efeito colateral é que a pilha nunca guarda uma barra alta *embaixo* de uma baixa. E é exatamente isso que torna a pilha útil: quando eu removo uma barra, quem sobra logo abaixo dela é, garantidamente, a primeira barra **menor à esquerda** — o meu limite `L`, de graça, sem procurar.

Avaliando a barra atual `i`, de altura `h`:

- Se `h` for **maior ou igual** à altura do topo da pilha, só empilho `i`. Ela não impede ninguém de crescer pra direita ainda.
- Se `h` for **menor** que a altura do topo, achei o **limite direito** (`R = i`) de todas as barras da pilha que são mais altas que `h`. Então eu vou tirando essas barras da pilha (`pop`), e pra cada uma calculo a área usando quem sobrou logo abaixo na pilha como **limite esquerdo** (`L`).

No fim do array eu jogo uma barra virtual de altura `0`, que serve de sentinela: ela é menor que tudo, então força a pilha a esvaziar e garante que todo retângulo que sobrou seja calculado.

## A solução em C++

```cpp
#include <bits/stdc++.h>
using namespace std;

class Solution {
public:
    int largestRectangleArea(vector<int>& heights) {
        stack<int> st;
        int max_area = 0;
        int n = heights.size();

        for (int i = 0; i <= n; i++) {
            int h = (i == n) ? 0 : heights[i];

            while (!st.empty() && h < heights[st.top()]) {
                int altura = heights[st.top()];
                st.pop();

                int largura = st.empty() ? i : (i - st.top() - 1);
                max_area = max(max_area, altura * largura);
            }
            st.push(i);
        }

        return max_area;
    }
};
```

## Lendo o código linha por linha

`for (int i = 0; i <= n; i++)` — repara no `<= n`. Eu itero uma posição *além* do array de propósito. Quando `i == n`, a altura vira `h = 0`, o sentinela que esvazia a pilha no final.

`int h = (i == n) ? 0 : heights[i];` — a altura da barra atual, ou `0` na iteração-sentinela.

`while (!st.empty() && h < heights[st.top()])` — enquanto a barra atual for **menor** que a do topo, é sinal de que o retângulo da barra do topo não consegue avançar mais pra direita. Chegou a hora de fechar a conta dele.

`int altura = heights[st.top()]; st.pop();` — guardo a altura do gargalo que estou fechando e removo o índice dele.

`int largura = st.empty() ? i : (i - st.top() - 1);` — a parte que mais me pegou. Se a pilha **esvaziou** depois do `pop`, a barra removida era a menor de todas até aqui, então ela se estende desde o começo: largura `i`. Se **não** esvaziou, o novo topo é a primeira barra menor à esquerda (`L`), e a largura útil é `i - st.top() - 1`.

`max_area = max(max_area, altura * largura);` — atualizo a resposta global.

`st.push(i);` — depois de fechar todo mundo que era mais alto, empilho a barra atual pra servir de limite esquerdo das próximas.

## Conferindo com um caso

Nada convence mais que rodar na mão. Vou passar o mesmo histograma do começo, `2 1 5 6 2 3`, pela solução — anotando a pilha (por índice) e a área toda vez que fecho uma barra:

```
heights = [2, 1, 5, 6, 2, 3]   (índices 0..5)

i=0  h=2  push 0                              pilha: [0]
i=1  h=1  1<2 → pop 0:  alt 2 × larg 1 = 2    pilha: []   ; push 1 → [1]
i=2  h=5  5≥1 → push 2                        pilha: [1,2]
i=3  h=6  6≥5 → push 3                        pilha: [1,2,3]
i=4  h=2  2<6 → pop 3:  alt 6 × larg 1 = 6    pilha: [1,2]
          2<5 → pop 2:  alt 5 × larg 2 = 10   pilha: [1]    ← maior!
          2≥1 → push 4                        pilha: [1,4]
i=5  h=3  3≥2 → push 5                        pilha: [1,4,5]
i=6  h=0  (sentinela)
          0<3 → pop 5:  alt 3 × larg 1 = 3
          0<2 → pop 4:  alt 2 × larg 4 = 8
          0<1 → pop 1:  alt 1 × larg 6 = 6

resposta = 10
```

Repara no passo `i=4`: a queda de `6` pra `2` foi o gatilho que fechou, de uma vez, os dois retângulos que estavam "esperando" na pilha (o da altura `6` e o da altura `5`). Aquele `alt 5 × larg 2 = 10` é exatamente o retângulo destacado no diagrama lá do começo — e olha como a largura `2` saiu sozinha da conta `i - st.top() - 1 = 4 - 1 - 1`. Era essa a área que a minha primeira tentativa "deixava pra trás".

## Complexidade

```
Tempo:   O(N) amortizado
Memória: O(N)
```

Sobre o tempo: mesmo tendo um `while` dentro do `for`, cada índice entra na pilha **exatamente uma vez** e sai **no máximo uma vez**. O total de operações de pilha na execução inteira é limitado a `2N`, então é linear de verdade. A memória é a própria pilha, que no pior caso (histograma sempre subindo) guarda os `N` índices.

O que eu levo desse problema: o meu bug não estava em nenhum detalhe do código. Era a pergunta. Enquanto eu tentava fazer o retângulo *crescer* barra a barra, o problema era impossível de fechar em tempo linear. Travei, e em vez de ficar teimando eu fui estudar a solução — e o que ela me ensinou não foi um truque de pilha, foi trocar a pergunta pra "quem limita cada barra?". Com a pergunta certa, a pilha monotônica é quase consequência. Não teve sacada minha de gênio aqui; teve a humildade de ir ver como se faz e o cuidado de entender pra valer. Às vezes consertar a modelagem vale mais que consertar dez linhas de código.

zd4▮
