class CreateErpMiniStoresArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_mini_stores_articles do |t|
      t.string :image_url
      t.string :name
      t.text :content
      t.text :meta_keywords
      t.text :meta_description
      t.boolean :archived, default: false
      t.references :article_category, index: true, references: :erp_mini_stores_article_categories
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
