class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @articles = @user.articles
  end
  
  def new
       @user = User.new 
    end

    def create
        @user = User.new(user_params)
        respond_to do |format|
            if @user.save
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
        @user = User.find(params[:id])            
    end
    def update
        @user = User.find(params[:id])
        
        respond_to do |format|
          if @user.update(user_params)
            format.html do
              flash[:notice] = "Your account info was successfully updated."
              redirect_to articles_path
            end
            format.turbo_stream { redirect_to articles_path, notice: 'Your account info was successfully updated.' }
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
end