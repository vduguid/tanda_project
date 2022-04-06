class OrganizationsController < ApplicationController
    def index
        p session[:user_id]
        @user = User.find_by_id(session[:user_id])
    end

    def new
        @organization = Organization.new
    end

    def create
        @user = current_user

        @organization = Organization.new(org_params)
        @user.organization_id = @organization.id
        if @organization.save
            redirect_to '/home'
          else
            render :new, status: :unprocessable_entity
          end
    end

    private
    def org_params
      params.permit(:name, :rate)
    end
end
