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
      t.string :email
    end

    create_table :procurement_budget_limits do |t|
      t.belongs_to :budget_period
      t.belongs_to :group
      t.money :amount

      t.index [:budget_period_id, :group_id], unique: true
    end
    add_foreign_key(:procurement_budget_limits, :procurement_budget_periods, column: 'budget_period_id')
    add_foreign_key(:procurement_budget_limits, :procurement_groups, column: 'group_id')

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
      t.belongs_to :budget_period
      t.belongs_to :group
      t.belongs_to :user,              foreign_key: true
      t.string :model_description,     null: false
      t.integer :requested_quantity,     null: false
      t.integer :approved_quantity,    null: true
      t.integer :order_quantity,       null: true
      t.money :price
      t.string :supplier
      t.column :priority,              "ENUM('normal', 'high')"
      t.string :receiver,              null: true
      t.string :location,              null: true
      t.string :motivation,            null: true
      t.string :inspection_comment,    null: true

      t.datetime :created_at,       null: false
    end
    add_foreign_key(:procurement_requests, :procurement_budget_periods, column: 'budget_period_id')
    add_foreign_key(:procurement_requests, :procurement_groups, column: 'group_id')

    create_table :procurement_template_categories do |t|
      t.belongs_to :group
      t.string :name

      t.index [:group_id, :name], unique: true
    end
    add_foreign_key(:procurement_template_categories, :procurement_groups, column: 'group_id')

    create_table :procurement_templates do |t|
      t.belongs_to :template_category
      t.string :model_description, null: false
      t.money :price
      t.string :supplier
    end
    add_foreign_key(:procurement_templates, :procurement_template_categories, column: 'template_category_id')

    create_table :procurement_attachments do |t|
      t.belongs_to :request
      t.attachment :file
    end
    add_foreign_key(:procurement_attachments, :procurement_requests, column: 'request_id')

  end
end
