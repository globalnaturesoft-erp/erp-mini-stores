module Erp::MiniStores
  class ProductImage < ApplicationRecord
    belongs_to :product, optional: true
    mount_uploader :image_url, Erp::MiniStores::ProductImageUploader
  end
end
