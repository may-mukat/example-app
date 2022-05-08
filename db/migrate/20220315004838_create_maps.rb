class CreateMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :maps do |t|
      t.string :name, null: false, limit: 30
      # t.integer :create_user_id references

      t.timestamps

      t.index :name, unique: true
    end
  end
end
