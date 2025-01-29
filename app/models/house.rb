class House < ApplicationRecord
  belongs_to :user

  validates :ownership_status, presence: true, inclusion: { in: %w[owned rented] }
  # ownership_status pode ser "owned" (proprio) ou "rented"(alugado)
end
