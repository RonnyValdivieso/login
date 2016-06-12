class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :nickname
      t.string :image
      t.string :accesstoken
      t.string :refreshtoken

      t.timestamps null: false
    end
  end
end
