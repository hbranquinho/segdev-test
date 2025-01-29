require 'rails_helper'

RSpec.describe "Insurance API", type: :request do
  # Cria o payload válido para os testes
  let(:valid_payload) do
    {
      age: 35,
      dependents: 2,
      house: { ownership_status: "owned" },
      income: 0,
      marital_status: "married",
      risk_questions: [ 0, 1, 0 ],
      vehicle: { year: 2018 }
    }
  end

  let(:headers) { { "Content-Type": "application/json" } }

  describe "POST /api/v1/insurance/risk-profile" do
    context "com dados válidos" do
      # Testa se o endpoint retorna o perfil de risco correto
      it "retorna o perfil de risco correto e status 200" do
        post "/api/v1/insurance/risk-profile", params: valid_payload.to_json, headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body, symbolize_names: true)
        # Verifica se o perfil de risco retornado é o esperado
        expect(json_response).to include(
          auto: "economico",
          disability: "inelegivel",
          home: "economico",
          life: "padrao"
        )
      end

      it "salva os dados corretamente no banco" do
        # Espera que a requisição mude o número de usuários, casas e veículos no banco
        expect {
          post "/api/v1/insurance/risk-profile", params: valid_payload.to_json, headers: headers
        }.to change(User, :count).by(1)
          .and change(House, :count).by(1)
          .and change(Vehicle, :count).by(1)
      end
    end

    context "com dados inválidos" do
      it "retorna erro se o payload estiver vazio" do
        # Testa se o endpoint retorna erro ao enviar payload vazio
        post "/api/v1/insurance/risk-profile", params: {}.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to be_present
      end

      it "retorna erro se a idade for negativa" do
        # Testa se o endpoint retorna erro ao enviar idade negativa
        invalid_payload = valid_payload.merge(age: -5)

        post "/api/v1/insurance/risk-profile", params: invalid_payload.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to include("Age must be greater than or equal to 0")
      end

      it "retorna erro se marital_status for inválido" do
        # Testa se o endpoint retorna erro ao enviar marital_status inválido
        invalid_payload = valid_payload.merge(marital_status: "divorced")

        post "/api/v1/insurance/risk-profile", params: invalid_payload.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to include("Marital status is not included in the list")
      end
    end
  end
end
