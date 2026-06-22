class Builders::Helpers < SiteBuilder
  MESES_PT = %w[
    janeiro fevereiro março abril maio junho
    julho agosto setembro outubro novembro dezembro
  ].freeze

  def build
    # Formata uma data no estilo brasileiro: "17 de junho de 2026".
    helper :data_pt do |date|
      next "" if date.nil?
      "#{date.day} de #{MESES_PT[date.month - 1]} de #{date.year}"
    end
  end
end
