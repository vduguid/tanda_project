class ShiftsController < ApplicationController

    def new
        @user = current_user
        @organization = Organization.find_by_id(@user.organization_id)
    end

    def create
        @user = current_user
        @organization = Article.find(params[:organization_id])
        p shift_params[:date]
        @shift = @organization.shifts.create(user_id: @user.id, date: shift_params[:date], 
            start: shift_params[:start], end: shift_params[:end], break: shift_params[:break])
        redirect_to '/home'
    end
    
    private
       def shift_params
          params.require(:shift).permit(:date, :start, :end, :break)
        end
end
