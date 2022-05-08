class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :email,           null: false, limit: 254
      t.string  :password_digest, null: false
      t.boolean :admin_flag,      null: false, default: false   # admin
      t.boolean :delete_flag,     null: false, default: false   # is_delete
      # t.integer :delete_user_id, references

      t.timestamps
      t.index :email, unique: true
    end
  end
end
