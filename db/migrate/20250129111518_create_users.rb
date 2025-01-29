class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.integer :age, null: false
      t.integer :dependents, null: false
      t.integer :income, null: false, default: 0
      t.string :marital_status, null: false
      t.jsonb :risk_questions, null: false, default: []

      t.timestamps
    end
  end
end
