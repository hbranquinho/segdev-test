class Api::V1::InsuranceController < ApplicationController
  def risk_profile
    ActiveRecord::Base.transaction do
      # Criando o usuário com os dados recebidos
      user = User.create!(user_params)

      # Criando a casa (se existir no payload)
      user.create_house!(house_params) if house_params.present?

      # Criando o veículo (se existir no payload)
      user.create_vehicle!(vehicle_params) if vehicle_params.present?

      # Chamando o serviço com o objeto User
      result = RiskProfileCalculator.new(user).call

      render json: result, status: :ok
    end
  # Tratamento de erros
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.permit(:age, :dependents, :income, :marital_status, risk_questions: [])
  end

  def house_params
    params.require(:house).permit(:ownership_status) if params[:house].present?
  end

  def vehicle_params
    params.require(:vehicle).permit(:year) if params[:vehicle].present?
  end
end
