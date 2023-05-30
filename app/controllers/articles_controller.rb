class ArticlesController < ApplicationController
    include ActionView::RecordIdentifier
    before_action :set_article, only: [:show, :edit, :update, :destroy]

    def show
    end

    def index
        @articles = Article.all
    end

    def new
        @article = Article.new
        render 'new'
    end

    def edit
    end

    def create
        @article = Article.new(article_params)
        @article.user = User.first
        if @article.save
          flash[:notice] = "Article created successfully."
          redirect_to @article
        else
          respond_to do |format|
            format.html { render :new }
            format.turbo_stream { render turbo_stream: turbo_stream.append("articles", partial: "shared/errors", locals: { errors: @article.errors.full_messages }) }
          end
        end
      end
    
    def update
        if @article.update(article_params)
            flash[:notice] = "Article was updated successfully"
            redirect_to @article
        else
            render :edit
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

end