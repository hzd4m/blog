---
layout: default
---

<section class="home-hero">
  <p class="prompt"><span class="prompt-sig">zd4@zeyverso</span>:~$ cat oi.txt</p>
  <h1 class="hero-titulo" aria-hidden="true"><span class="cursor">▮</span></h1>
  <p class="hero-sub">Tecnologia, história e as ideias que não pude guardar na minha cabeça.</p>
</section>

<%
  recentes = collections.posts.resources
    .reject { |p| p.data.published == false }
    .sort_by { |p| p.data.date }
    .reverse
    .first(3)
%>

<h2 class="home-secao-titulo">Escrita recente</h2>

<% if recentes.empty? %>
  <p><em>Em breve.</em></p>
<% else %>
  <ul class="lista-posts">
    <% recentes.each do |post| %>
      <li class="item-post">
        <% if post.data.date %><time datetime="<%= post.data.date.strftime('%Y-%m-%d') %>"><%= data_pt(post.data.date) %></time><% end %>
        <h2><a href="<%= post.relative_url %>"><%= post.data.title %></a></h2>
        <% if post.data.description %><p><%= post.data.description %></p><% end %>
      </li>
    <% end %>
  </ul>
  <p class="home-mais"><a href="<%= relative_url '/posts' %>">ver todos os posts →</a></p>
<% end %>

<h2 class="home-secao-titulo">Prateleiras</h2>
<ul class="home-chips">
  <% (site.data.nav&.dig("categorias") || []).each do |cat| %>
    <li><a href="<%= relative_url '/posts' %>"><%= cat["nome"] %></a></li>
  <% end %>
  <li><a href="<%= relative_url '/projetos/' %>">Projetos</a></li>
</ul>
