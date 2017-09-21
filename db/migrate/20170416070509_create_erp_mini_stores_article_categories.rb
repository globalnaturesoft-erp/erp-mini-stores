class CreateErpMiniStoresArticleCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_mini_stores_article_categories do |t|
      t.string :name
      t.integer :parent_id
      t.string :alias
      t.integer :custom_order
      t.text :meta_keywords
      t.text :meta_description
      t.text :meta_image
      t.boolean :hot_category, default: false
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
