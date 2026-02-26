class UsersController < ApplicationController
  # Skip login check for new/create so people can actually sign up
  skip_before_action :require_login, only: [:new, :create]
  before_action :correct_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id # Log them in immediately
      redirect_to tasks_path, notice: t("users.notice.created")
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  # ... edit and update methods ...
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: t("users.notice.updated")
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to tasks_path, notice: t("users.notice.forbidden")
    end
  end
end