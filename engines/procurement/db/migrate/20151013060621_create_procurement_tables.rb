class CreateProcurementTables < ActiveRecord::Migration
  def change

    create_table :procurement_budget_periods do |t|
      t.string :name,                 null: false
      t.date :inspection_start_date,  null: false
      t.date :end_date,               null: false, index: true

      t.datetime :created_at,         null: false
    end

    create_table :procurement_groups do |t|
      t.string :name
    end

    create_table :procurement_group_responsibles do |t|
      t.belongs_to :user
      t.belongs_to :group
      # TODO deleted_at ??

      t.index [:user_id, :group_id], unique: true
    end
    add_foreign_key(:procurement_group_responsibles, :users)
    add_foreign_key(:procurement_group_responsibles, :procurement_groups, column: 'group_id')

    create_table :procurement_accesses do |t|
      t.belongs_to :user,   index: true
      t.boolean :is_admin,  index: true
    end
    add_foreign_key(:procurement_accesses, :users)

    create_table :procurement_organizations do |t|
      t.string :name
      t.string :shortname
      t.belongs_to :parent, index: true
    end
    add_foreign_key(:procurement_organizations, :procurement_organizations, column: 'parent_id')

    create_table :procurement_requests do |t|
      t.belongs_to :group,          null: false
      t.belongs_to :user,           null: false
      t.string :description,        null: false
      t.integer :desired_quantity,  null: false
      t.integer :approved_quantity, null: true
      t.money :price
      t.string :supplier

      t.datetime :created_at,       null: false, index: true

      t.index [:user_id, :created_at]
    end
    add_foreign_key(:procurement_requests, :users)
    add_foreign_key(:procurement_requests, :procurement_groups, column: 'group_id')

    create_table :procurement_request_templates do |t|
      t.belongs_to :group,   null: false, index: true
      t.string :description, null: false
      t.money :price
      t.string :supplier
    end
    add_foreign_key(:procurement_request_templates, :procurement_groups, column: 'group_id')

    create_table :procurement_attachments do |t|
      t.belongs_to :request, null: false, index: true
      t.attachment :file
    end

  end
end
