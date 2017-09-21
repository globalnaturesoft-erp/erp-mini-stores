class CreateErpMiniStoresSlideshows < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_mini_stores_slideshows do |t|
      t.string :image_url
      t.string :name
      t.string :link
      t.string :title
      t.boolean :archived, default: false
      t.integer :custom_order
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
