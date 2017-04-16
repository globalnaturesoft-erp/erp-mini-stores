class CreateErpMiniStoresProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_mini_stores_products do |t|
      t.string :code
      t.string :name
      t.string :short_name
      t.decimal :price
      t.string :is_deal
      t.string :deal_price
      t.string :deal_percent
      t.text :description
      t.text :meta_keywords
      t.text :meta_description
      t.boolean :archived, default: false
      t.references :brand, index: true, references: :erp_mini_stores_brands
      t.references :category, index: true, references: :erp_mini_stores_categories
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
