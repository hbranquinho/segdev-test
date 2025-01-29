require 'rails_helper'

RSpec.describe House, type: :model do
  subject { build(:house) } # Cria uma casa temporária sem salvar no banco

  # Testa se os atributos obrigatórios estão presentes
  it { should belong_to(:user) }
  it { should validate_presence_of(:ownership_status) }
  it { should validate_inclusion_of(:ownership_status).in_array(%w[owned rented]) }
end
