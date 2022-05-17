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
        p @shifts
        @shifts_sort = @shifts.sort_by(&:start).reverse
    end

    def create
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)

        @full_date = params[:shift][:"date(1i)"] + "-" + params[:shift][:"date(2i)"] + "-" + params[:shift][:"date(3i)"]

        if shift_params[:start] == ""
            redirect_to user_shifts_path(@user)
        else 

            start_string = @full_date + " " + shift_params[:start]
            @datetime_start = DateTime.parse(start_string)

            end_string = @full_date + " " + shift_params[:end]
            @datetime_finish = DateTime.parse(end_string)
        
            @hours_worked = ((Time.parse(shift_params[:end]).to_i - Time.parse(shift_params[:start]).to_i).fdiv(3600)) - (((Time.parse(shift_params[:break])).to_i).fdiv(60))

            @overnight = 0
            if @hours_worked < 0
                @overnight = 1
            end

            if @user.shifts.create(start: @datetime_start, finish: @datetime_finish, break: shift_params[:break], overnight: @overnight)
                redirect_to user_shifts_path(@user)
            else
                render :new, status: :unprocessable_entity
            end
        end
    end

    def edit
        @user = current_user
        @organization = Organization.find(@user.organization_id)
        @shift = @user.shifts.find(params[:id])
        @date = @shift.start.strftime("%m/%d/%Y")
    end

    def update
        @user = current_user
        @organization = Organization.find(@user.organization_id)
        @shift = @user.shifts.find(params[:id])

        @full_date = params[:shift][:"start(1i)"] + "-" + params[:shift][:"start(2i)"] + "-" + params[:shift][:"start(3i)"]
        
        if shift_params[:start] == ""
            redirect_to user_shifts_path(@user)
        else 

            start_string = @full_date + " " + edit_params[:start]
            @datetime_start = DateTime.parse(start_string)

            end_string = @full_date + " " + edit_params[:finish]
            @datetime_finish = DateTime.parse(end_string)
            if @shift.update(start: @datetime_start, finish: @datetime_finish, break: edit_params[:break])
                redirect_to user_shifts_path(@user)
            else
                render :edit, status: :unprocessable_entity
            end
        end
    end

    #this is a destroy method but rails was being annoying
    def show
        @user = current_user
        @shift = @user.shifts.find(params[:id])
        @shift.destroy
        redirect_to user_shifts_path(@user)
    end
    
    private
       def shift_params
          params.require(:shift).permit(:date, :start, :end, :break)
        end

        private
        def edit_params
           params.require(:shift).permit(:date, :start, :finish, :break)
         end
end
