class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # Start with all tasks
    @tasks = Task.all

    # 1. Search Logic
    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.search_title(params[:search][:title])
      end
      
      if params[:search][:status].present?
        @tasks = @tasks.search_status(params[:search][:status])
      end
    endd

    # 2. Sorting Logic
    if params[:sort_deadline_on]
      # Apply deadline sorting if the link was clicked
      @tasks = @tasks.sort_deadline_on
    elsif params[:sort_priority]
      # Apply priority sorting if the link was clicked
      @tasks = @tasks.sort_priority
    else
      # Default: Sort by newest created (from Step 2)
      @tasks = @tasks.sort_created_at
    end

    # 3. Pagination (This must happen last!)
    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      # UPDATE THIS LINE to use the translation helper
      redirect_to tasks_path, notice: t('flash.tasks.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.tasks.destroy')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end
end