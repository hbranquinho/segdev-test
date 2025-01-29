require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) } # Cria um usuário temporário sem salvar no banco

  # Testa se os atributos obrigatórios estão presentes
  it { should validate_presence_of(:age) }
  it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0) }

  it { should validate_presence_of(:dependents) }
  it { should validate_numericality_of(:dependents).is_greater_than_or_equal_to(0) }

  it { should validate_presence_of(:income) }
  it { should validate_numericality_of(:income).is_greater_than_or_equal_to(0) }

  it { should validate_presence_of(:marital_status) }
  it { should validate_inclusion_of(:marital_status).in_array(%w[single married]) }

  it { should validate_presence_of(:risk_questions) } # Garante que o array está presente

  describe "Validação de risk_questions" do
    it "deve ser inválido se não for um array de 3 valores" do
      subject.risk_questions = [ 0, 1 ] # Apenas dois valores
      expect(subject).to_not be_valid
      expect(subject.errors[:risk_questions]).to include("deve ser um array de 3 valores de 0 ou 1")
    end

    it "deve ser inválido se os valores não forem 0 ou 1" do
      subject.risk_questions = [ 0, 2, 1 ] # 2 não é válido
      expect(subject).to_not be_valid
      expect(subject.errors[:risk_questions]).to include("deve ser um array de 3 valores de 0 ou 1")
    end

    it "deve ser válido com um array de 3 valores 0 ou 1" do
      subject.risk_questions = [ 0, 1, 0 ] # Array válido
      expect(subject).to be_valid
    end
  end
end
