class CreateErpMiniStoresMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_mini_stores_messages do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :content

      t.timestamps
    end
  end
end
