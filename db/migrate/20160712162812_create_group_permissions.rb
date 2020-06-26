# frozen_string_literal: true

class CreateGroupPermissions < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :group_permissions do |t|
      t.references :group
      t.string :permission

      t.timestamps null: false
    end
  end
end
