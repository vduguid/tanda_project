class UsersController < ApplicationController

  def reset
  end

  def update
    @user = User.find_by(email: params[:users][:email])
    p params[:users][:email]
    if @user
      @user.pass = params[:users][:newpass]
      @user.save
      redirect_to root_path
    end
  end

  def details
    @user = current_user
  end

  def update_name
    @user =  current_user
    @new_name = params[:users][:name]
    @user.name = @new_name
    @user.save
    
  end

  def update_email
    @user =  current_user
    @new_email = params[:users][:email]
    @user.email = @new_email
    @user.save
  end

  def update_pass
    @user =  current_user
    @old_pass = params[:users][:old_pass]
    @new_pass = params[:users][:new_pass]
    if @user.authenticate(@old_pass)
      @user.pass = @new_pass
      @user.save
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

  
  
  # extend ActiveModel::Naming
  
  # def initialize
  #   @err = ActiveModel::Errors.new(self)
  # end
  # attr_accessor :check_pass
  # attr_reader   :err

  # def match_error
  #   if !(@first_pass.eql?(@check_pass))
  #     p @error_msg
  #   end
  #    err.add(@check_pass, :blank, message: "Passwords do not match") if !(@first_pass.eql?(@check_pass))
  #   #err.add(@check_pass, :blank, message: "Password confirmation can't be blank") if @check_pass.nil?
  # end
  # public
  # def read_attribute_for_validation(check_pass)
  #   send(check_pass)
  # end
  # public
  # def self.human_attribute_name(attr, options = {})
  #   attr
  # end
  # public
  # def self.lookup_ancestors
  #   [self]
  # end
  
  # helper_method :match_error
  


end
