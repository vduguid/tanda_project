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

        p shift_params[:shift]

        if shift_params[:start] == ""
            redirect_to user_shifts_path(@user)
        else 

            start_string = @full_date + " " + shift_params[:start]
            @datetime_start = DateTime.parse(start_string)

            end_string = @full_date + " " + shift_params[:end]
            @datetime_finish = DateTime.parse(end_string)

            p @datetime_finish
        

            if @user.shifts.create(start: @datetime_start, finish: @datetime_finish, break: shift_params[:break])
                redirect_to user_shifts_path(@user)
            else
                render :new, status: :unprocessable_entity
            end
        end
    end
    
    private
       def shift_params
          params.require(:shift).permit(:date, :start, :end, :break)
        end
end
