module Erp::MiniStores
  class Article < ApplicationRecord
		validates :name, :content, :article_category_id, :presence => true
		mount_uploader :image_url, Erp::MiniStores::ArticleImageUploader
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :article_category, class_name: "Erp::MiniStores::ArticleCategory"
    
    def self.get_active
			self.where(archived: false)
		end
    
    # get newest articles
    def self.newest_articles(limit=nil)
			records = self.get_active.order('erp_mini_stores_articles.created_at DESC')
			records = records.joins(:article_category).where("erp_mini_stores_article_categories.alias = ?", Erp::MiniStores::ArticleCategory::ALIAS_ARTICLE).limit(3)
		end
    
    # get newest articles
    def self.get_newest_articles
			records = self.get_active.order('erp_mini_stores_articles.created_at DESC')
			records = records.joins(:article_category).where("erp_mini_stores_article_categories.alias = ?", Erp::MiniStores::ArticleCategory::ALIAS_ARTICLE)
		end
    
    # get newest articles
    def self.get_about_us_article
			records = self.get_active.order('erp_mini_stores_articles.created_at DESC')
			records = records.joins(:article_category).where("erp_mini_stores_article_categories.alias = ?", Erp::MiniStores::ArticleCategory::ALIAS_ABOUT).first
		end
    
    # get all blogs
    def self.get_all_blogs(params)
			query = self.get_active
			if params[:blog_id].present?
        arr_cat = Erp::MiniStores::ArticleCategory.find(params[:blog_id]).get_self_and_children_ids
				query = query.where(article_category_id: arr_cat)
			else
				query = query.joins(:article_category).where('erp_mini_stores_article_categories.alias = ?', Erp::MiniStores::ArticleCategory::ALIAS_ARTICLE)
			end
			query = query.order('erp_mini_stores_articles.created_at DESC')
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
      
      # join with article categories table for search with articles
      query = query.joins(:article_category)
      
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
      
      query = query.limit(8).map{|article| {value: article.id, text: article.name} }
    end
    
    def article_category_name
			article_category.present? ? article_category.name : ''
		end
    
    def article_name
			self.name
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
  end
end
