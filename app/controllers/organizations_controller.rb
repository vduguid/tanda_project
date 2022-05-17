class OrganizationsController < ApplicationController
    def index
        @user = current_user
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
        @user.shifts.destroy_all
        @user.update(organization_id: nil)
        redirect_to '/home/new'
    end

    def shifts
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
    end

    def new
        @organizations = Organization.all
        @user = current_user
        @organization = Organization.new
    end

    def create
        @user = current_user
        @organization = Organization.new(org_params)
        
        if @organization.save
            @user.update(organization_id: @organization.id)
            redirect_to '/home'
        else
            redirect_to '/home/new'
        end
    end

    def edit
        @user = current_user
        @organization = Organization.find_by_id(params[:id])
    end

    def update
        @user = current_user
        @organization = Organization.find_by_id(params[:id])


        if @organization.update(org_params)
            if (@user.organization_id)
                redirect_to '/home'
            else
                redirect_to '/home/new'
            end
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @organization = Organization.find_by_id(params[:id])
        @organization.destroy
        redirect_to '/home/new'
    end

    private
    def org_params
      params.require(:organization).permit(:name, :rate)
    end
end
