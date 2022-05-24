class UsersController < ApplicationController

  def reset
  end

  def update
    @user = User.find_by(email: params[:users][:email])
    if @user
      @user.pass = params[:users][:newpass]
      @user.save
      redirect_to root_path
    end
  end

  def settings
    @user = current_user
  end

  def go_home
    @user = current_user
    if @user.organization_id
      redirect_to home_path
    else
      redirect_to '/home/new'
    end
  end

  def update_name
    @user =  current_user
    @new_name = params[:users][:name]
    @user.name = @new_name
    if @user.save
      flash[:success] = "Name updated"
      if @user.organization_id
        redirect_to home_path
      else
        redirect_to '/home/new'
      end
    else
      render :settings, status: :unprocessable_entity
    end
  end

  def update_email
    @user =  current_user
    @new_email = params[:users][:email]
    @user.email = @new_email
    @user.save
    if @user.save
      if @user.organization_id
        redirect_to home_path
      else
        redirect_to '/home/new'
      end
    else
      render :settings, status: :unprocessable_entity
    end
  end

  def update_pass
    @user =  current_user
    @old_pass = params[:users][:old_pass]
    @new_pass = params[:users][:new_pass]
    if @user.authenticate(@old_pass)
      @user.pass = @new_pass
      if @user.save
        if @user.organization_id
          redirect_to home_path
        else
          redirect_to '/home/new'
        end
      end
    else
      render :settings, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @first_pass = @user.pass
    @check_pass = confirm_password["conf_pass"]
    @error_msg = "Passwords must match"
    if !(@first_pass.eql?(@check_pass))
      p @error_msg
      valid_params = false
      @user.errors.add( "Passwords must match" )
      render :new, status: :unprocessable_entity
    end
    if @user.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :pass)
    end
  private
    def confirm_password
      params.require(:user).permit(:conf_pass)
    end

  
  
  


end
