class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :require_login

  # GET /tasks
  def index
  # Chain the two model class methods directly
    @tasks = current_user.tasks.apply_filtering(params)
                .apply_sorting(params)
                .page(params[:page])
                .per(10)
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.new
  end

  # POST /tasks
  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: t("tasks.notice.created")
    else
      render :new
    end
  end

  # GET /tasks/:id
  def show
  end

  # GET /tasks/:id/edit
  def edit
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("tasks.notice.updated")
    else
      render :edit
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t("tasks.notice.destroyed")
  end

  private

  # Use callbacks to share common setup
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # Only allow trusted parameters
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
