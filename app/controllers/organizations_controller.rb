class OrganizationsController < ApplicationController
    def index
        p session[:user_id]
        @user = User.find_by_id(session[:user_id])
    end

    def new
    end

    def create
    end
end
