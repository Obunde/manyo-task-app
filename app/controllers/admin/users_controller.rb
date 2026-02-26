class Admin::UsersController < ApplicationController

  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
	  @users = User.includes(:tasks)
	end

	def new
    @user = User.new
  end

	def create 
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: t("admin.users.notice.created")
    else
      render :new
    end
  end

	def show; end

	def edit; end

	def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: t("admin.users.notice.updated")
    else
      @user.errors.full_messages.each { |msg| Rails.logger.info msg }
      render :edit
    end
  end

	def destroy 
    @user.destroy
    redirect_to admin_users_path, notice: t("admin.users.notice.destroyed")
  else
    redirect_to admin_users_path, notice: t("admin.users.notice.destroy_failed")
  end

  private

  def require_admin
   unless current_user&.admin?
		redirect_to root_path, notice: t("admin.users.notice.forbidden")
   end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
