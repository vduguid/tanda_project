class ShiftsController < ApplicationController

    def index
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
        @users = User.where(organization_id: @organization.id)
        @shifts = @user.shifts.all
        @users.each do |user|
            if @user != user
                @shifts += user.shifts.all
            end
        end
        @shifts_sort = @shifts.sort_by(&:start).reverse

        #filters
    end

    def emp_filter
        @logged_user = current_user
        @organization = Organization.find_by_id(@logged_user.organization_id)
        @employee_name = params[:name]
        @user = User.find_by(name: @employee_name)
        @shifts = @user.shifts.where(organization_id: @organization.id)
        @shifts_sort = @shifts.sort_by(&:start).reverse
    end

    def view_dep
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
        @shifts = Shift.where(organization_id: @organization.id, status: "departed")
    end

    def create
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)

        @full_date = shift_params[:"date(1i)"] + "-" + shift_params[:"date(2i)"] + "-" + shift_params[:"date(3i)"]

        if shift_params[:start] == "" || shift_params[:end] == "" || shift_params[:"date(1i)"] == "" || shift_params[:"date(2i)"] == "" || shift_params[:"date(3i)"] == ""
            redirect_to user_shifts_path(@user)
        else 

            start_string = @full_date + " " + shift_params[:start]
            @datetime_start = DateTime.parse(start_string)

            end_string = @full_date + " " + shift_params[:end]
            @datetime_finish = DateTime.parse(end_string)

        
            @hours_worked = ((Time.parse(shift_params[:end]).to_i - Time.parse(shift_params[:start]).to_i).fdiv(3600)) - ((shift_params[:break]).to_i).fdiv(60)

            @overnight = 0
            if @hours_worked < 0
                @overnight = 1
            end

            @status = "current"

            if @user.shifts.create(start: @datetime_start, finish: @datetime_finish, 
                break: shift_params[:break], overnight: @overnight, status: @status, organization_id: @organization.id)
                redirect_to user_shifts_path(@user)
            else
                render :new, status: :unprocessable_entity
            end
        end
    end

    def edit
        @user = current_user
        @organization = Organization.find(@user.organization_id)
        @shift = Shift.find(params[:id])
        @date = @shift.start.strftime("%m/%d/%Y")
    end

    def update
        @user = current_user
        @organization = Organization.find(@user.organization_id)
        @shift = Shift.find(params[:id])

        @full_date = edit_params[:"start(1i)"] + "-" + edit_params[:"start(2i)"] + "-" + edit_params[:"start(3i)"]
        
        if edit_params[:start] == "" || edit_params[:end] == "" || edit_params[:"start(1i)"] == "" || edit_params[:"start(2i)"] == "" || edit_params[:"start(3i)"] == ""
            redirect_to user_shifts_path(@user)
        else 

            start_string = @full_date + " " + edit_params[:start]
            @datetime_start = DateTime.parse(start_string)

            end_string = @full_date + " " + edit_params[:finish]
            @datetime_finish = DateTime.parse(end_string)

            @hours_worked = ((Time.parse(edit_params[:finish]).to_i - Time.parse(edit_params[:start]).to_i).fdiv(3600)) - ((edit_params[:break]).to_i).fdiv(60)

            @overnight = 0
            if @hours_worked < 0
                @overnight = 1
            end

            @status = "current"

            if @shift.update(start: @datetime_start, finish: @datetime_finish, 
                break: edit_params[:break], overnight: @overnight, status: @status, organization_id: @organization.id)
                redirect_to user_shifts_path(@user)
            else
                render :edit, status: :unprocessable_entity
            end
        end
    end

    #this is a destroy method but rails was being annoying
    def show
        @user = current_user
        @shift = Shift.find(params[:id])
        @shift.destroy
        redirect_to user_shifts_path(@user)
    end
    
    private
       def shift_params
          params.require(:shift).permit(:"date(1i)", :"date(2i)", :"date(3i)", :start, :end, :break)
        end

        private
        def edit_params
           params.require(:shift).permit(:"start(1i)", :"start(2i)", :"start(3i)", :start, :finish, :break)
         end
end
