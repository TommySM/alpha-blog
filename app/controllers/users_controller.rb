class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  
  def show
      @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)

  end
  
  def new
       @user = User.new
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
              session[:user_id] = @user.id
              format.html do
                flash[:notice] = "Welcome to the Alpha Blog, you have successfully signed up"
                redirect_to articles_path
              end
              format.turbo_stream { redirect_to articles_path, notice: 'Welcome to the Alpha Blog, you have successfully signed up' }
            else
              format.html { render :new }
              format.turbo_stream { render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { errors: @user.errors.full_messages, errors_record_name: "User" }) }
            end
          end            
    end

    def edit
    end

    def update        
        respond_to do |format|
          if @user.update(user_params)
            format.html do
              flash[:notice] = "Your account info was successfully updated."
              redirect_to @user
            end
            format.turbo_stream { redirect_to @user, notice: 'Your account info was successfully updated.' }
          else
            format.html { render :edit }
            format.turbo_stream { render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { errors: @user.errors.full_messages, errors_record_name: "User" }) }
          end
        end
      end
      
      private
      def user_params
        params.require(:user).permit(:username, :email, :password, :profile_images)
      end

      def set_user
        @user = User.find(params[:id])
      end

end