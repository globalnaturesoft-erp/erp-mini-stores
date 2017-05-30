module Erp
  module MiniStores
    module Backend
      class ProductsController < Erp::Backend::BackendController
        before_action :set_product, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_products, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /products
        def index
        end
    
        # POST /products/list
        def list
          @products = Product.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /products/new
        def new
          @product = Product.new
          
          8.times do
            @product.product_images.build
          end
        end
    
        # GET /products/1/edit
        def edit
          (8 - @product.product_images.count).times do
            @product.product_images.build
          end
        end
    
        # POST /products
        def create
          @product = Product.new(product_params)
          @product.creator = current_user
          
          8.times do
            @product.product_images.build
          end
          
          if @product.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }
            else
              redirect_to erp_mini_stores.edit_backend_product_path(@product), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /products/1
        def update
          (8 - @product.product_images.count).times do
            @product.product_images.build
          end
          
          if @product.update(product_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }              
            else
              redirect_to erp_mini_stores.edit_backend_product_path(@product), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /products/1
        def destroy
          @product.destroy

          respond_to do |format|
            format.html { redirect_to erp_mini_stores.backend_products_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /products/archive?id=1
        def archive
          @product.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /products/archive?id=1
        def unarchive
          @product.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /products/delete_all?ids=1,2,3
        def delete_all         
          @products.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /products/archive_all?ids=1,2,3
        def archive_all         
          @products.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /products/unarchive_all?ids=1,2,3
        def unarchive_all
          @products.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: Product.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_product
            @product = Product.find(params[:id])
          end
          
          def set_products
            @products = Product.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def product_params
            params.fetch(:product, {}).permit(:code, :name, :short_name, :price, :is_deal, :is_bestseller, :deal_price, :deal_percent, :description, :product_type,
                                            :brand_id, :category_id, :meta_keywords, :meta_description,
                                            :product_images_attributes => [ :id, :image_url, :image_url_cache, :product_id, :_destroy ])
          end
      end
    end
  end
end