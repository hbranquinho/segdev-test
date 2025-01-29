# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'factory_bot_rails'
require 'faker'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
# Para carregar arquivos auxiliares em `spec/support/`
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Configuração para FactoryBot (uso simplificado de `create(:user)` ao invés de `FactoryBot.create(:user)`)
  config.include FactoryBot::Syntax::Methods

  # Permite acessar as rotas do Rails nos testes
  config.include Rails.application.routes.url_helpers

  # Definição de caminho para fixtures (se estiver utilizando)
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]

  # Se estiver usando ActiveRecord, manter como true para testes transacionais
  config.use_transactional_fixtures = true

  # Para suportar testes de requests (como `post` e `get` dentro dos specs)
  config.infer_spec_type_from_file_location!

  # Filtra linhas desnecessárias do Rails nos logs de erro
  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
