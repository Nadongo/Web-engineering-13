class Admin::UsersController < ApplicationController
  # 1. LOCK IT DOWN: Only admins allowed!
  before_action :require_admin
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    # 2. SOLVE THE N+1 PROBLEM: 
    # Using `.includes(:tasks)` loads all users AND their tasks in just 2 queries,
    # instead of doing 1 query for users, and then 50 extra queries for their task counts!
    @users = User.includes(:tasks).all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'ユーザーを登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザーを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'ユーザーを削除しました'
    else
      # If the model callback blocks the deletion (e.g., last admin), show the error!
      redirect_to admin_users_path, alert: @user.errors.full_messages.first
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Notice we added :admin here so administrators can assign roles!
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end