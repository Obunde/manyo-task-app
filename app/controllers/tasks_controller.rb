class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  # GET /tasks
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
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
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow trusted parameters
  def task_params
    params.require(:task).permit(:title, :content)
  end
end
