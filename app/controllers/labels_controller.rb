class LabelsController < ApplicationController
  before_action :require_login
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = current_user.labels
  end

  def new
    @label = current_user.labels.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to labels_path, notice: "I have registered a label"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: "Updated labels"
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: "Labels have been removed"
  end

  private

  def set_label
    @label = current_user.labels.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end