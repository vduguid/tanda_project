class ApplicationController < ActionController::Base

    def current_user
        @user = User.find(cookies.signed[:user_id])
        p @user
    end

    helper_method :current_user
end
