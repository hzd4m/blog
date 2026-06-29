---
layout: page
title: Posts
---

<%
  publicados = collections.posts.resources
    .reject { |p| p.data.published == false }
    .sort_by { |p| p.data.date }
    .reverse

  categorias = site.data.nav&.dig("categorias") || []
%>

<% categorias.each do |cat| %>
  <%
    da_prateleira = publicados.select { |p| Array(p.data.categories).include?(cat["nome"]) }
  %>
  <% next if da_prateleira.empty? %>

  <section class="prateleira" id="<%= cat["slug"] %>">
    <h2 class="home-secao-titulo"><%= cat["nome"] %></h2>
    <ul class="lista-posts">
      <% da_prateleira.each do |post| %>
        <li class="item-post">
          <% if post.data.date %><time datetime="<%= post.data.date.strftime('%Y-%m-%d') %>"><%= data_pt(post.data.date) %></time><% end %>
          <h3><a href="<%= post.relative_url %>"><%= post.data.title %></a></h3>
          <% if post.data.description %><p><%= post.data.description %></p><% end %>
        </li>
      <% end %>
    </ul>
  </section>
<% end %>
