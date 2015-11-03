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

    create_table :procurement_group_inspectors do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :group
      # TODO deleted_at ??

      t.index [:user_id, :group_id], unique: true
    end
    add_foreign_key(:procurement_group_inspectors, :procurement_groups, column: 'group_id')

    create_table :procurement_accesses do |t|
      t.belongs_to :user,   foreign_key: true
      t.boolean :is_admin,  index: true
    end

    create_table :procurement_organizations do |t|
      t.string :name
      t.string :shortname
      t.belongs_to :parent
    end
    add_foreign_key(:procurement_organizations, :procurement_organizations, column: 'parent_id')

    create_table :procurement_requests do |t|
      t.belongs_to :group
      t.belongs_to :user,              foreign_key: true
      t.string :description,           null: false
      t.integer :desired_quantity,     null: false
      t.integer :approved_quantity,    null: true
      t.integer :order_quantity,    null: true
      t.money :price
      t.string :supplier
      t.integer :priority,             null: false, default: 2  # 1 = high, 2 = medium
      t.string :motivation,            null: true
      t.string :receiver,              null: true

      t.datetime :created_at,       null: false, index: true

      t.index [:user_id, :created_at]
    end
    add_foreign_key(:procurement_requests, :procurement_groups, column: 'group_id')

    create_table :procurement_request_templates do |t|
      t.belongs_to :group
      t.string :description, null: false
      t.money :price
      t.string :supplier
    end
    add_foreign_key(:procurement_request_templates, :procurement_groups, column: 'group_id')

    create_table :procurement_attachments do |t|
      t.belongs_to :request
      t.attachment :file
    end
    add_foreign_key(:procurement_attachments, :procurement_requests, column: 'request_id')

  end
end
