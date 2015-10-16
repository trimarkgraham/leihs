class CreateProcurementRequests < ActiveRecord::Migration
  def change
    create_table :procurement_requests do |t|
      t.belongs_to :user,             null: false
      t.string :description,          null: false
      t.integer :desired_quantity,    null: false
      t.integer :approved_quantity,   null: true
      t.decimal :price, precision: 10, scale: 2 # TODO money gem
      t.string :supplier

      t.datetime :created_at,         null: false

      t.index :created_at
      t.index [:user_id, :created_at]
    end
  end
end
