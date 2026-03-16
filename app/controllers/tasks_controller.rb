class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :ensure_correct_user, only: %i[ show edit update destroy ]

  def index
    @tasks = current_user.tasks

    # 1. Sorting Logic
    if params[:sort_deadline_on]
      @tasks = @tasks.order(deadline_on: :asc)
    elsif params[:sort_priority]
      @tasks = @tasks.order(priority: :desc)
    else
      @tasks = @tasks.order(created_at: :desc)
    end

    # 2. Search / Filtering Logic
    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.where('tasks.title LIKE ?', "%#{params[:search][:title]}%")
      end
      if params[:search][:status].present?
        @tasks = @tasks.where(tasks: { status: params[:search][:status] })
      end
      if params[:search][:label_id].present?
        @tasks = @tasks.joins(:labels).where(labels: { id: params[:search][:label_id] })
      end
    end

    # 3. Pagination
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
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "タスクを登録しました"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを更新しました"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end

  def ensure_correct_user
    @task = Task.find(params[:id])
    unless @task.user == current_user
      redirect_to tasks_path, notice: "権限がありません"
    end
  end
end