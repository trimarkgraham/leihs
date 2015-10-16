class CreateProcurementBudgetPeriods < ActiveRecord::Migration
  def change
    create_table :procurement_budget_periods do |t|
      t.string :name,                 null: false
      t.date :inspection_start_date,  null: false
      t.date :end_date,               null: false

      t.datetime :created_at,         null: false

      t.index :end_date
    end
  end
end
