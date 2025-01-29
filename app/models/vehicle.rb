class Vehicle < ApplicationRecord
  belongs_to :user

  validates :year, presence: true, numericality: { only_integer: true, greater_than: 1800 }
  # atributo: year contem um inteiro com o ano de fabricação do veiculo
  # adicionado validação para garantir que o ano seja maior que 1800
end
