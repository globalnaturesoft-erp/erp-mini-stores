class CreateErpMiniStoresProductImages < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_mini_stores_product_images do |t|
      t.string :image_url
      t.references :product, index: true, references: :erp_mini_stores_products

      t.timestamps
    end
  end
end
