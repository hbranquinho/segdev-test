
# Segdev - API de Perfil de Risco para Seguros

## Visão Geral

Esta API recebe informações do usuário e retorna um perfil de risco para seguros baseado em critérios predefinidos. Os seguros avaliados são:

-  **Auto** (seguro automotivo)

-  **Disability** (seguro de invalidez)

-  **Home** (seguro residencial)

-  **Life** (seguro de vida)


A API classifica o risco de cada seguro como:

-  **"econômico"**

-  **"padrão"**

-  **"avançado"**

-  **"inelegível"** (caso o usuário não se qualifique)


---


## Tecnologias Utilizadas

-  **Ruby on Rails 7**

-  **PostgreSQL** (banco de dados)

-  **RSpec** (testes automatizados)

-  **FactoryBot + Faker** (dados de teste)

---

## Configuração do Ambiente


 **1 - Pré-requisitos****

Antes de começar, instale:

-  **Ruby 3.2+**

-  **Rails 7+**

-  **PostgreSQL**

-  **Bundler** (se ainda não estiver instalado)

`gem  install  bundler`

**2 - Instalação do Projeto**
```
git clone https://github.com/seuusuario/segdev-api.git
cd segdev-api
bundle install
```


**3 - Configuração do Banco de Dados**
`rails db:create db:migrate`
**Testes**
`RAILS_ENV=test rails db:create db:migrate`


# Como utilizar a API

**1 - Endpoint disponível**

```POST /api/v1/insurance/risk-profile```

**2 - Exemplo de requisição**
```
{
	"age": 35,
	"dependents": 2,
	"house": {"ownership_status": "owned"},
	"income": 0,
	"marital_status": "married",
	"risk_questions": [0, 1, 0],
	"vehicle": {"year": 2018}
}
  ```

**Exemplo de resposta**
```
{
	"auto": "economico",
	"disability": "inelegivel",
	"home": "economico",
	"life": "padrao"
}
```

**3 - Possíveis Erros**
| `422 Unprocessable Entity` | Payload inválido (ex: idade negativa, estado civil incorreto) |
| `400 Bad Request` | Requisição malformada |

**Exemplo de Erro**
```
{
	"age": -5,
	"dependents": 2,
	"house": {"ownership_status": "owned"},
	"income": 0,
	"marital_status": "married",
	"risk_questions": [0, 1, 0],
	"vehicle": {"year": 2018}
}
```

**Resposta Esperada (`422 Unprocessable Entity`)**
```
{
	"error": ["Age must be greater than or equal to 0"]
}```

# Executando Testes

**1 - Rodar Todos os Testes**
`bundle exec rspec`

**2 - Rodar Apenas os Testes da API**
`bundle exec rspec spec/requests/insurance_spec.rb`
