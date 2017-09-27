module Erp
  module MiniStores
    module Backend
      class ArticleCategoriesController < Erp::Backend::BackendController
        before_action :set_article_category, only: [:archive, :unarchive, :edit, :update, :destroy, :move_up, :move_down]
        before_action :set_article_categories, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /article_categories
        def index
        end
        
        # POST /article_categories/list
        def list
          @article_categories = ArticleCategory.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /article_categories/new
        def new
          @article_category = ArticleCategory.new
        end
    
        # GET /article_categories/1/edit
        def edit
        end
    
        # POST /article_categories
        def create
          @article_category = ArticleCategory.new(article_category_params)
          @article_category.creator = current_user
          
          if @article_category.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @article_category.name,
                value: @article_category.id
              }
            else
              redirect_to erp_mini_stores.edit_backend_article_category_path(@article_category), notice: t('.success')
            end
          else
            if params.to_unsafe_hash['format'] == 'json'
              render '_form', layout: nil, locals: {article_category: @article_category}
            else
              render :new
            end            
          end
        end
    
        # PATCH/PUT /article_categories/1
        def update
          if @article_category.update(article_category_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @article_category.name,
                value: @article_category.id
              }
            else
              redirect_to erp_mini_stores.edit_backend_article_category_path(@article_category), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /article_categories/1
        def destroy
          @article_category.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_mini_stores.backend_article_categories_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Archive /article_categories/archive?id=1
        def archive      
          @article_category.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Unarchive /article_categories/unarchive?id=1
        def unarchive
          @article_category.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # DELETE /article_categories/delete_all?ids=1,2,3
        def delete_all         
          @article_categories.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /article_categories/archive_all?ids=1,2,3
        def archive_all         
          @article_categories.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /article_categories/unarchive_all?ids=1,2,3
        def unarchive_all
          @article_categories.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: ArticleCategory.dataselect(params[:keyword])
            }
          end
        end
        
        # Move up /article_categories/up?id=1
        def move_up      
          @article_category.move_up
          
          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end          
        end
        
        # Move down /article_categories/up?id=1
        def move_down     
          @article_category.move_down
          
          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end          
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_article_category
            @article_category = ArticleCategory.find(params[:id])
          end
          
          def set_article_categories
            @article_categories = ArticleCategory.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def article_category_params
            params.fetch(:article_category, {}).permit(:name, :parent_id, :alias, :hot_category, :is_main, :icon_main, :meta_image, :meta_keywords, :meta_description)
          end
      end
    end
  end
end