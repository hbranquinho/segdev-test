require 'rails_helper'

RSpec.describe RiskProfileCalculator, type: :service do
  # Criação de um usuário válido para os testes
  let(:user) do
    create(:user,
      age: 35,
      dependents: 2,
      income: 0,
      marital_status: 'married',
      risk_questions: [ 0, 1, 0 ]
    )
  end

  # Criando casa e veículo associados ao usuário antes dos testes
  before do
    create(:house, ownership_status: 'owned', user: user)
    create(:vehicle, year: 2018, user: user)
  end

  context "Cálculo do Base Score" do
    it "deve calcular corretamente o base_score" do
      # O base_score deve ser igual à soma das risk_questions [0, 1, 0] = 1
      service = RiskProfileCalculator.new(user)
      expect(service.send(:initialize_scores)[:auto]).to eq(1)
    end
  end

  context "Regras de Inelegibilidade" do
    it "deve tornar disability inelegível se income for 0" do
      # Se a renda for 0, disability deve ser inelegível
      user.update(income: 0)
      result = RiskProfileCalculator.new(user).call
      expect(result[:disability]).to eq("inelegivel")
    end

    it "deve tornar auto inelegível se não houver veículo" do
      # Se o usuário não tem veículo, auto deve ser inelegível
      user.vehicle.destroy
      user.reload
      result = RiskProfileCalculator.new(user).call
      expect(result[:auto]).to eq("inelegivel")
    end

    it "deve tornar home inelegível se não houver casa" do
      # Se o usuário não tem casa, home deve ser inelegível
      user.house.destroy
      user.reload
      result = RiskProfileCalculator.new(user).call
      expect(result[:home]).to eq("inelegivel")
    end
  end
end
