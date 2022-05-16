class ShiftsController < ApplicationController

    def index
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
    end

    def create
        @user = current_user
        @organization = Organization.find(params[:organization_id])

        @full_date = params[:shift][:"date(1i)"] + "-" + params[:shift][:"date(2i)"] + "-" + params[:shift][:"date(3i)"]

        start_string = @full_date + " " + shift_params[:start]
        @datetime_start = DateTime.parse(start_string)
        p @datetime_start

        end_string = @full_date + " " + shift_params[:end]
        @datetime_finish = DateTime.parse(end_string)
        p @datetime_finish


        @shift = @organization.shifts.create(user_id: @user.id,
            start: @datetime_start, finish: @datetime_finish, break: shift_params[:break])
        redirect_to organization_shifts_path(@organization)
    end
    
    private
       def shift_params
          params.require(:shift).permit(:date, :start, :end, :break)
        end
end
