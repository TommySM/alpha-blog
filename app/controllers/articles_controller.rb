class ArticlesController < ApplicationController
  include WillPaginate::ViewHelpers  
  include ActionView::RecordIdentifier
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index] 
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
    end

    def index
      @articles = Article.paginate(page: params[:page], per_page: 5)
    end
    

    def new
        @article = Article.new
        render 'new'
    end

    def edit
    end

    def create
      @article = Article.new(article_params)
      @article.user = current_user
      respond_to do |format|
        if @article.save
          format.html { redirect_to @article, notice: 'Article was successfully created.' }
          format.turbo_stream { redirect_to @article, notice: 'Article was successfully created.' }
        else
          format.html { render :new }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { errors: @article.errors.full_messages, errors_record_name: "Article" }) }
        end
      end
    end
    
    def update
      respond_to do |format|
        if @article.update(article_params)
          format.html do
            flash[:notice] = "Article was updated successfully"
            redirect_to @article
          end
          format.turbo_stream { redirect_to @article, notice: 'Article was successfully updated.' }
        else
          format.html { render :edit }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { errors: @article.errors.full_messages, errors_record_name: "Article" }) }
        end
      end
    end
    
    def destroy
        @article.destroy
        redirect_to articles_path        
    end

    private

    def set_article
    @article = Article.find(params[:id]) 
    end

    def article_params
        params.require(:article).permit(:title, :description)
    end

    def require_same_user
      if current_user != @article.user && !current_user.admin?
        flash[:alert] = "You can only edit or delete your own article"
        redirect_to @article        
      end
      
    end

end