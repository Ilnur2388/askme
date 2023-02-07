class UsersController < ApplicationController
  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:name, :nickname, :email, :password)

    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: 'Вы успешно зарегистировались!'
    else
      flash.now[:alert] = 'Вы неправильно заполнили поля регистрации'
      render :new
    end
  end
end
