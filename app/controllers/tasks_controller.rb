class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks
  def index
    # 1. Start with a base scope (do not use .page yet)
    @tasks = Task.all

    # 2. Handle Sorting (Chain these to the base scope)
    if params[:sort_deadline_on]
      @tasks = @tasks.sort_by_deadline
    elsif params[:sort_priority]
      @tasks = @tasks.sort_by_priority
    else
      @tasks = @tasks.recent
    end

    # 3. Handle Filtering (Chain these as well)
    if params[:search].present?
      @tasks = @tasks.search_title(params[:search][:title]) if params[:search][:title].present?
      @tasks = @tasks.search_status(params[:search][:status]) if params[:search][:status].present?
    end

    # 4. Final step: Paginate the fully built query
    @tasks = @tasks.page(params[:page]).per(10)
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
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
    @task = Task.find(params[:id])
  end

  # Only allow trusted parameters
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end
