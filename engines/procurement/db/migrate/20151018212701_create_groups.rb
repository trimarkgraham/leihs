class CreateGroups < ActiveRecord::Migration
  def change

    create_table :procurement_groups do |t|
      t.string :name
    end

    create_table :procurement_group_accesses do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.boolean :is_responsible
      # TODO deleted_at ??

      t.index [:user_id, :group_id], unique: true
      t.index :is_responsible
    end

    add_foreign_key(:procurement_group_accesses, :users)
    add_foreign_key(:procurement_group_accesses, :procurement_groups, column: 'group_id')

    add_foreign_key(:procurement_requests, :procurement_groups, column: 'group_id')

  end
end
