class RiskProfileCalculator
  def initialize(user)
    @user = user
    @base_score = user.risk_questions.sum # Soma as respostas binárias para determinar o score base
  end

  def call
    scores = initialize_scores
    apply_rules(scores)
    map_scores_to_plans(scores)
  end

  private

  def initialize_scores
    { auto: @base_score, disability: @base_score, home: @base_score, life: @base_score }
  end

  def apply_rules(scores)
    # Regras de inelegibilidade
    scores[:home] = "inelegivel" if @user.house.nil?
    scores[:auto] = "inelegivel" if @user.vehicle.nil?
    scores[:life] = "inelegivel" if @user.age > 60
    scores[:disability] = "inelegivel" if @user.income == 0
    scores[:disability] = "inelegivel" if @user.age > 60
    adjust_scores_based_on_conditions(scores)
  end

  def adjust_scores_based_on_conditions(scores)
    age_penalty = @user.age < 30 ? -2 : @user.age.between?(30, 40) ? -1 : 0
    income_penalty = @user.income > 200_000 ? -1 : 0

    # Aplicar ajustes globais
    scores.each do |insurance, score|
      next if score == "inelegivel"
      scores[insurance] += age_penalty + income_penalty
    end

    # Ajustes baseados na casa
    if @user.house&.ownership_status == "rented"
      scores[:home] += 1 unless scores[:home] == "inelegivel"
      scores[:disability] += 1 unless scores[:disability] == "inelegivel"
    end

    # Ajustes baseados em dependentes
    if @user.dependents.positive?
      scores[:disability] += 1 unless scores[:disability] == "inelegivel"
      scores[:life] += 1 unless scores[:life] == "inelegivel"
    end

    # Ajustes baseados no estado civil
    if @user.marital_status == "married"
      scores[:life] += 1 unless scores[:life] == "inelegivel"
      scores[:disability] -= 1 unless scores[:disability] == "inelegivel"
    end

    # Ajuste baseado no veículo (se fabricado nos últimos 5 anos)
    if @user.vehicle&.year.to_i >= (Time.now.year - 5)
      scores[:auto] += 1 unless scores[:auto] == "inelegivel"
    end
  end

  def map_scores_to_plans(scores)
    scores.transform_values do |score|
      next score if score == "inelegivel"

      case score
      when 0..0 then "economico"
      when 1..2 then "padrao"
      else "avancado"
      end
    end
  end
end
