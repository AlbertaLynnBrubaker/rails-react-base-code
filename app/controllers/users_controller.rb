class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def show
    render json: current_user, status: :ok
  end

  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = current_user
    user.update!(user_params)
    render json: user, status: :accepted
  end

  def destroy
    current_user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
