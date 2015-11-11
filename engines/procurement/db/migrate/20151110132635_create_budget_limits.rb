class CreateBudgetLimits < ActiveRecord::Migration
  def change
    create_table :procurement_budget_limits do |t|
      t.belongs_to :budget_period, index: true
      t.belongs_to :group, index: true
      t.money :amount

      t.index [:budget_period_id, :group_id], unique: true
    end
  end
end
