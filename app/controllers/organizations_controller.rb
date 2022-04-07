class OrganizationsController < ApplicationController
    def index
        p session[:user_id]
        @user = User.find_by_id(session[:user_id])
        @organization = Organization.find_by_id(@user.organization_id)
    end

    def join 
        @user = current_user
        @organization = Organization.find_by(name: params[:x])
        @user.update(organization_id: @organization.id)
        redirect_to '/home'
    end

    def leave 
        @user = current_user
        @user.update(organization_id: nil)
        redirect_to '/home/new'
    end


    def new
        @organisations = Organization.all
        @user = current_user
        @organization = Organization.new
    end

    def create
        
        @organization = Organization.new(org_params)
        
        if @organization.save
            @user.update(organization_id: @organization.id)
            redirect_to '/home'
          else
            render :new, status: :unprocessable_entity
          end
    end

    def edit
        @user = current_user
        @organization = Organization.find_by_id(params[:id])
    end

    def update
        @organization = Organization.find_by_id(params[:id])

        p params[:name]
        p params[:rate]

        if @organization.update(name: params[:name], rate: params[:rate])
            redirect_to '/home'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
    def org_params
      params.require(:organization).permit(:name, :rate)
    end
end
