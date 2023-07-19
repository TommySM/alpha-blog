class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  include WillPaginate::ViewHelpers 

    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        respond_to do |format|
          if @category.save
            format.html do
              flash[:notice] = "Category was successfully created."
              redirect_to @category
            end
            format.turbo_stream { redirect_to @category, notice: "Category was successfully created." }
          else
            format.html { render :new }
            format.turbo_stream { render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { errors: @category.errors.full_messages, errors_record_name: "Category" }) }
          end
        end
      end
      

      def edit
        @category = Category.find(params[:id])
      end

      def update
        @category = Category.find(params[:id])
        if @category.update(category_params)
          flash[:notice] = "Category name updated succesfully"
          redirect_to @category
        else
          render 'edit'
        end
      end

    def index
      @categories = Category.paginate(page: params[:page], per_page: 5)
    end

    def show
      @category = Category.find(params[:id])
      @articles = @category.articles.paginate(page: params[:page], per_page: 5)
    end

    private

    def category_params
        params.require(:category).permit(:name)        
    end

    def require_admin
      if !(logged_in? && current_user.admin?)
        flash[:alert] = "Only admins can perform that action"
        redirect_to categories_path
      end
    end
end
