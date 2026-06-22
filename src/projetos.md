---
layout: default
title: Projetos
permalink: /projetos/
---

<h1>Projetos</h1>
<p class="projetos-intro">Coisas que eu construí — código que virou produto, protótipo ou experimento.</p>

<%
  projetos = collections.projetos.resources.sort_by { |p| p.data.ordem.to_i }
%>

<% if projetos.empty? %>
  <p><em>Nenhum projeto publicado ainda.</em></p>
<% else %>
  <ul class="projetos-lista">
    <% projetos.each do |proj| %>
      <% capa = proj.data.capa || proj.data.galeria&.first&.dig("src") %>
      <li class="projeto-card">
        <% if capa %>
          <a href="<%= proj.relative_url %>"><img src="<%= relative_url(capa) %>" alt="<%= proj.data.title %>" loading="lazy" /></a>
        <% end %>
        <div>
          <h2><a href="<%= proj.relative_url %>"><%= proj.data.title %></a></h2>
          <% if proj.data.tech %><p class="projeto-meta"><%= Array(proj.data.tech).join(" · ") %></p><% end %>
          <% if proj.data.descricao %><p><%= proj.data.descricao %></p><% end %>
        </div>
      </li>
    <% end %>
  </ul>
<% end %>
