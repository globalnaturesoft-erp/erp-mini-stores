module Erp::MiniStores
  class Product < ApplicationRecord
		#mount_uploader :image_url, Erp::MiniStores::BrandImageUploader
		validates :name, :uniqueness => true
    validates :name, :presence => true
    validates :price, :category_id, :brand_id, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category, class_name: "Erp::MiniStores::Category"
    belongs_to :brand, class_name: "Erp::MiniStores::Brand"
    
    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image_url].blank? and a[:image_url_cache].blank? }, :allow_destroy => true
    
    after_save :destroy_images_url_nil?
    
    TYPE_VERTICAL = 'vertical'
    TYPE_HORIZONTAL = 'horizontal'
    
    def self.get_product_type_options()
      [
        {text: I18n.t('vertical'),value: self::TYPE_VERTICAL},
        {text: I18n.t('horizontal'),value: self::TYPE_HORIZONTAL}
      ]
    end
    
    # get product main images
    def main_image
			product_images.first
		end
    
    def self.get_active
			self.where(archived: false)
		end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      # show archived items condition - default: false
			show_archived = false
			
			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						# in case filter is show archived
						if cond[1]["name"] == 'show_archived'
							# show archived items
							show_archived = true
						else
							or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
						end
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      
      # join with users table for search creator
      query = query.joins(:creator)
      
      # showing archived items if show_archived is not true
			query = query.where(archived: false) if show_archived == false

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        
        query = query.order(order)
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|product| {value: product.id, text: product.name} }
    end
    
    def category_name
			category.present? ? category.name : ''
		end
    
    def brand_name
			brand.present? ? brand.name : ''
		end
    
    def archive
			update_columns(archived: true)
		end
		
		def unarchive
			update_columns(archived: false)
		end
    
    def self.archive_all
			update_all(archived: true)
		end
    
    def self.unarchive_all
			update_all(archived: false)
		end
    
    def self.get_products_for_category(params)
			self.get_active.where(category_id: params[:category_id])
		end
    
    def self.get_newest_products(limit=5)
			self.get_active.order('created_at ASC').limit(limit)
		end
    
    def self.get_bestseller_products
			self.get_active.where(is_bestseller: 'true')
		end
    
    def self.get_hot_deal_products
			self.get_active.where(is_deal: 'true')
		end
    
    def get_related_products
			Erp::MiniStores::Product.get_active.where(category_id: self.category_id)
		end
    
    def destroy_images_url_nil?
			self.product_images.where(image_url: nil).destroy_all
		end
    
    def self.get_horizontal_products
			self.where(product_type: Erp::MiniStores::Product::TYPE_HORIZONTAL)
		end
    
    def self.get_vertical_products
			self.where(product_type: Erp::MiniStores::Product::TYPE_VERTICAL)
		end
    
  end
end