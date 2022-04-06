class SessionsController < ApplicationController
    def new 
        @user = User.new
    end

    def create
        @user = User.find_by_email(params[:sessions][:email])
    
        if @user && @user.authenticate(params[:sessions][:pass])
            session[:user_id] = @user.id
            if @user.organization_id
                redirect_to home_path
            else
                redirect_to '/home/new'
            end
        else
            p "Login failed"
            redirect_to '/login'
        end
    end

    def destroy
        session.delete :user_id
        redirect_to root_path
    end

    def home

    end
end
