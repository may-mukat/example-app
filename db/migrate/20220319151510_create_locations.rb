class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.decimal    :x_coordinate  , null: false, precision: 5, scale: 1
      t.decimal    :y_coordinate  , null: false
      t.references :map           , null: false, foreign_key: true
      t.references :loot_container, null: false, foreign_key: true
      t.references :user          , null: false, foreign_key: true

      t.timestamps
    end
  end
end
