module Erp::MiniStores
  class ArticleCategory < ApplicationRecord
    include Erp::CustomOrder
		validates :name, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :parent, class_name: "Erp::MiniStores::ArticleCategory", optional: true
    has_many :children, class_name: "Erp::MiniStores::ArticleCategory", foreign_key: "parent_id"
    has_many :articles, class_name: "Erp::MiniStores::Article"
    
    after_save :update_level
    
    # class const
    ALIAS_ARTICLE = 'article' # Bài viết
    ALIAS_ABOUT = 'about_us' # Về chúng tôi
    ALIAS_TOUR_GUIDE = 'tour_guide' # Hướng dẫn mua hàng
    ALIAS_CUSTOMER_CARE = 'customer_care' # Chăm sóc khách hàng
    ALIAS_TERMS_OF_SALES = "terms_of_sales" # Điều khoản mua bán hàng hóa
    ALIAS_PAYMENT_METHODS = 'payment_methods' # Phương thức thanh toán
    ALIAS_RETURN_POLICY_AND_REFUND = 'return_policy_and_refund' # Chính sách đổi trả & hoàn tiền
    ALIAS_POLICY_OF_DISPUTES_COMPLAINTS = 'policy_of_disputes_complaints' # Chính sách giải quyết tranh chấp & khiếu nại
    
    ALIAS_POLICY_GROUP = [ALIAS_TOUR_GUIDE, ALIAS_CUSTOMER_CARE, ALIAS_TERMS_OF_SALES, ALIAS_PAYMENT_METHODS,
													ALIAS_RETURN_POLICY_AND_REFUND, ALIAS_RETURN_POLICY_AND_REFUND, ALIAS_POLICY_OF_DISPUTES_COMPLAINTS]
    
    # get alias for article category
    def self.get_alias_options()
      [
				{text: I18n.t('article'), value: self::ALIAS_ARTICLE},
        {text: I18n.t('about_us'), value: self::ALIAS_ABOUT},
        {text: I18n.t('tour_guide'), value: self::ALIAS_TOUR_GUIDE},
        {text: I18n.t('customer_care'), value: self::ALIAS_CUSTOMER_CARE},
        {text: I18n.t('terms_of_sales'), value: self::ALIAS_TERMS_OF_SALES},
        {text: I18n.t('payment_methods'), value: self::ALIAS_PAYMENT_METHODS},
        {text: I18n.t('return_policy_and_refund'), value: self::ALIAS_RETURN_POLICY_AND_REFUND},
        {text: I18n.t('policy_of_disputes_complaints'), value: self::ALIAS_POLICY_OF_DISPUTES_COMPLAINTS}
			]
		end
    
    def self.get_active
			self.where(archived: false)
		end
    
    def self.get_category_by_alias_blog
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_ARTICLE).first
		end
    
    def self.get_category_by_alias_about_us
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_ABOUT).first
		end
    
    def self.get_category_by_alias_tour_guide
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_TOUR_GUIDE).first
		end
    
    def self.get_category_by_alias_customer_care
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_CUSTOMER_CARE).first
		end
    
    def self.get_category_by_alias_terms_of_sales
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_TERMS_OF_SALES).first
		end
    
    def self.get_category_by_alias_payment_methods
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_PAYMENT_METHODS).first
		end
    
    def self.get_category_by_alias_return_policy_and_refund
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_RETURN_POLICY_AND_REFUND).first
		end
    
    def self.get_category_by_alias_policy_of_disputes_complaints
			query = self.get_active.where(parent_id: nil)
			query = query.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_POLICY_OF_DISPUTES_COMPLAINTS).first
		end

    # get self and children ids
    def get_self_and_children_ids
      ids = [self.id]
      ids += get_children_ids_recursive
      return ids
		end

    # get children ids recursive
    def get_children_ids_recursive
      ids = []
      children.each do |c|
				if !c.children.empty?
					ids += c.get_children_ids_recursive
				end
				ids << c.id
			end
      return ids
		end

    # update level
    def update_level
			level = 1
			parent = self.parent
			while parent.present?
				level += 1
				parent = parent.parent
			end

			level
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

      # join with parent article categories table for search article categories
      query = query.joins("LEFT JOIN erp_mini_stores_article_categories parents_erp_mini_stores_article_categories ON parents_erp_mini_stores_article_categories.id = erp_mini_stores_article_categories.parent_id")

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
      query = self.all.order("created_at desc")

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|article_category| {value: article_category.id, text: article_category.name} }
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
		
		# display name
    def article_category_name
			self.name
		end
		
    # display name
    def parent_name
			parent.present? ? parent.name : ''
		end

		# display name with parent
    def full_name
			names = [self.name]
			p = self.parent
			while !p.nil? do
				names << p.name
				p = p.parent
			end
			names.reverse.join(" >> ")
		end

    # Get get all archive
    def self.all_unarchive
			self.where(archived: false)
		end
    
  end
end
