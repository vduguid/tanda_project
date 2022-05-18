class OrganizationsController < ApplicationController
    def index
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
    end

    def join 
        @user = current_user
        @organization = Organization.find_by(name: params[:x])
        @user.update(organization_id: @organization.id)
        #readd user's past shifts
        @shifts = Shift.where(organization_id: @organization.id, user_id: @user.id)
        @shifts.each do |shift|
            shift.update(status: "current")
        end
        redirect_to '/home'
    end

    def leave 
        @user = current_user
        #normally we would destroy the user's shifts, but we're just going to archive them!
        @shifts = @user.shifts.all
        @shifts.each do |shift|
            shift.update(status: "departed")
        end
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
        @user = current_user
        if @user.organization_id
            @user.update(organization_id: nil)
        end
        @organization.destroy
        redirect_to '/home/new', method: "get"
    end

    private
    def org_params
      params.require(:organization).permit(:name, :rate)
    end
end
