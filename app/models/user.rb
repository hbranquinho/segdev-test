class User < ApplicationRecord
  # Um usuário pode ter uma casa e um veículo (opcional)
  has_one :house, dependent: :destroy
  has_one :vehicle, dependent: :destroy

  # Validações obrigatórias
  validates :age, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # Idade: Um inteiro maior ou igual a zero

  validates :dependents, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # Numero de dependentes: Um inteiro maior ou igual a zero

  validates :income, numericality: { greater_than_or_equal_to: 0 }, presence: true
  # Renda anual: Um inteiro maior ou igual a zero

  validates :marital_status, presence: true, inclusion: { in: %w[single married] }
  # Status civil ("single" or "married")

  validates :risk_questions, presence: true
  validate :risk_questions_validate
  # Questões de risco (Um array com 3 booleanos)

  private

  def risk_questions_validate
    puts "risk_questions: #{risk_questions}"
    unless risk_questions.is_a?(Array) && risk_questions.length == 3 && risk_questions.all? { |q| [ 0, 1 ].include?(q) }
      errors.add(:risk_questions, "deve ser um array de 3 valores de 0 ou 1")
    end
  end
end
