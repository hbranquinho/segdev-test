require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  subject { build(:vehicle) } # Cria um veículo temporário sem salvar no banco

  # Testa se os atributos obrigatórios estão presentes
  it { should belong_to(:user) }
  it { should validate_presence_of(:year) }
  it { should validate_numericality_of(:year).only_integer.is_greater_than(1800) }

  describe "Validação do ano do veículo" do
    it "deve ser inválido se o ano for menor que 1800" do
      # Ano menor que 1800
      subject.year = 1799
      expect(subject).to_not be_valid
      expect(subject.errors[:year]).to include("must be greater than 1800")
    end

    it "deve ser válido com um ano maior que 1800" do
      # Ano maior que 1800
      subject.year = 2000
      expect(subject).to be_valid
    end
  end
end
