class CreateOkiniiris < ActiveRecord::Migration[5.0]
  def change
    create_table :okiniiris do |t|
      t.references :user, foreign_key: true
      t.references :micropost, foreign_key: true

      t.timestamps
      t.index [:user_id, :micropost_id], unique: true    #user_idとmicropost_idの重複登録を防ぐ
    end
  end
end
