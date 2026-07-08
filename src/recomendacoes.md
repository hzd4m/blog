---
layout: page
title: Recomendações
permalink: /recomendacoes/
---

<p>Coisas que me marcaram e eu acho que valem o seu tempo: filme, livro, música, artigo, entrevista — o que for. Sem ranking, sem resenha longa, só o ponteiro e o porquê.</p>

<%
  tipos = [
    { chave: "filme",      nome: "Filmes" },
    { chave: "livro",      nome: "Livros" },
    { chave: "musica",     nome: "Música" },
    { chave: "artigo",     nome: "Artigos" },
    { chave: "video",      nome: "Vídeos" },
    { chave: "entrevista", nome: "Entrevistas" },
    { chave: "outros",     nome: "Outros" },
  ]

  todas = collections.recomendacoes.resources.sort_by { |r| r.data.data.to_s }.reverse
  conhecidos = tipos.map { |t| t[:chave] } - ["outros"]
%>

<% tipos.each do |tipo| %>
  <%
    da_secao = if tipo[:chave] == "outros"
      todas.reject { |r| conhecidos.include?(r.data.tipo) }
    else
      todas.select { |r| r.data.tipo == tipo[:chave] }
    end
  %>
  <% next if da_secao.empty? %>

  <section class="prateleira" id="<%= tipo[:chave] %>">
    <h2 class="home-secao-titulo"><%= tipo[:nome] %></h2>
    <ul class="lista-posts">
      <% da_secao.each do |rec| %>
        <li class="item-post">
          <h3>
            <% if rec.data.link %>
              <a href="<%= rec.data.link %>" rel="noopener"><%= rec.data.title %></a>
            <% else %>
              <%= rec.data.title %>
            <% end %>
          </h3>
          <% if rec.data.autor %><p class="rec__autor"><%= rec.data.autor %></p><% end %>
          <div class="rec__nota"><%= rec.content %></div>
        </li>
      <% end %>
    </ul>
  </section>
<% end %>

<% if collections.recomendacoes.resources.empty? %>
  <p><em>Em breve.</em></p>
<% end %>
