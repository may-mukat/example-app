class CreateLootContainers < ActiveRecord::Migration[7.0]
  def change
    create_table :loot_containers do |t|
      t.string :name, null: false, limit: 30   #unique
      # t.integer :create_user_id references

      t.timestamps
    end
  end
end
