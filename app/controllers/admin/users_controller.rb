class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  def index
    @users = User.includes(:tasks)
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: t("admin.users.notice.created")
    else
      render :new
    end
  end

  # GET /admin/users/:id
  def show
    @user = User.find(params[:id])
    # Get the tasks belonging to THIS user and paginate them
    @tasks = @user.tasks.page(params[:page]).per(10)
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # PATCH/PUT /admin/users/:id
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: t("admin.users.notice.updated")
    else
      @user.errors.full_messages.each { |msg| Rails.logger.info msg }
      render :edit
    end
  end

  # DELETE /admin/users/:id
  def destroy
    @user = User.find(params[:id])
    
    if @user.destroy
      # If an admin deletes themselves, log them out. 
      # Otherwise, just redirect back to the list.
      if @user == current_user
        session.delete(:user_id)
        redirect_to new_session_path, notice: t("admin.users.notice.deleted")
      else
        redirect_to admin_users_path, notice: t("admin.users.notice.deleted")
      end
    else
      # This captures the "Cannot delete last admin" error from the Model callback
      redirect_to admin_users_path, notice: @user.errors.full_messages.join(", ")
    end
  end

  private

  # Only admins can access these actions
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, notice: t("admin.users.notice.forbidden")
    end
  end

  # Set user for actions that need it
  def set_user
    @user = User.find(params[:id])
  end

  # Strong parameters
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end