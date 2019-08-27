# frozen_string_literal: true

class CreateGroupPermissions < ActiveRecord::Migration
  def change
    create_table :group_permissions do |t|
      t.references :group
      t.string :permission

      t.timestamps null: false
    end
  end
end
