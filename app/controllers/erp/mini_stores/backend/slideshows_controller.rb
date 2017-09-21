module Erp
  module MiniStores
    module Backend
      class SlideshowsController < Erp::Backend::BackendController
        before_action :set_article, only: [:archive, :unarchive, :show, :edit, :update, :destroy, :move_up, :move_down]
        before_action :set_slideshows, only: [:delete_all, :archive_all, :unarchive_all]
        
        def index
        end
        
        # GET /slideshows
        def list
          @slideshows = Slideshow.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end

        # GET /slideshows/new
        def new
          @slideshow = Slideshow.new

          if request.xhr?
            render '_form', layout: nil, locals: {article: @slideshow}
          end
        end

        # GET /slideshows/1/edit
        def edit
        end

        # POST /slideshows
        def create
          @slideshow = Slideshow.new(slideshow_params)
          @slideshow.creator = current_user

          if @slideshow.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @slideshow.id,
                value: @slideshow.name
              }
            else
              redirect_to erp_slideshows.edit_backend_article_path(@slideshow), notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {article: @slideshow}
            else
              render :new
            end
          end
        end

        # PATCH/PUT /slideshows/1
        def update
          if @slideshow.update(slideshow_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @slideshow.id,
                value: @slideshow.name
              }
            else
              redirect_to erp_slideshows.edit_backend_article_path(@slideshow), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /slideshows/1
        def destroy
          @slideshow.destroy

          respond_to do |format|
            format.html { redirect_to erp_slideshows.backend_slideshows_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE /slideshows/delete_all?ids=1,2,3
        def delete_all
          @slideshows.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Archive /slideshows/archive?id=1
        def archive
          @slideshow.archive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Unarchive /slideshows/unarchive?id=1
        def unarchive
          @slideshow.unarchive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Archive /slideshows/archive_all?ids=1,2,3
        def archive_all
          @slideshows.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Unarchive /slideshows/unarchive_all?ids=1,2,3
        def unarchive_all
          @slideshows.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # dataselect /slideshows
        def dataselect
          respond_to do |format|
            format.json {
              render json: Slideshow.dataselect(params[:keyword])
            }
          end
        end

        # Move up /categories/up?id=1
        def move_up
          @slideshow.move_up

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end
        end

        # Move down /categories/up?id=1
        def move_down
          @slideshow.move_down

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
          def set_article
            @slideshow = Slideshow.find(params[:id])
          end

          def set_slideshows
            @slideshows = Slideshow.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def slideshow_params
            params.fetch(:article, {}).permit(:image_url, :name, :link, :title)
          end
      end
    end
  end
end