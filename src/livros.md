---
layout: default
title: Livros
permalink: /livros/
---

<section style="max-width: 700px; margin: 0 auto; padding: 2rem 1rem; font-family: Georgia, 'Times New Roman', serif; line-height: 1.7;">

  <header style="margin-bottom: 2rem;">
    <h1 style="margin: 0 0 0.5rem;">Livros</h1>
    <p style="color: #555; font-size: 1.05rem;">
      Aqui você encontra meus livros disponibilizados gratuitamente. Cada livro é escrito
      em público, capítulo a capítulo, e atualizado conforme aprendo coisas novas.
    </p>
  </header>

  <%
    livros = collections.livros.resources.sort_by { |l| l.data.ordem.to_i }
  %>

  <% if livros.empty? %>
    <p><em>Nenhum livro publicado ainda.</em></p>
  <% else %>
    <ul style="list-style: none; padding: 0;">
      <% livros.each do |livro| %>
        <li style="margin: 1.5rem 0; padding: 1.2rem; border: 1px solid #eee; background: #fafafa;">
          <h2 style="margin: 0 0 0.4rem; font-size: 1.4rem;">
            <a href="<%= livro.relative_url %>" style="color: #0a4d8c; text-decoration: none;">
              <%= livro.data.title %>
            </a>
          </h2>
          <p style="margin: 0 0 0.5rem; color: #777; font-size: 0.9rem;">
            por <%= livro.data.autor %><% if livro.data.ano %> &middot; <%= livro.data.ano %><% end %>
          </p>
          <% if livro.data.descricao %>
            <p style="margin: 0;"><em><%= livro.data.descricao %></em></p>
          <% end %>
        </li>
      <% end %>
    </ul>
  <% end %>

</section>
