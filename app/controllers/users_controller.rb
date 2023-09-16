class UsersController < ApplicationController
  before_action :logged_in_user

  def new
    session[:current_time] = Time.now
    @user = User.new
  end

  def create

    @user = User.new(user_params)

    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Пожалуйста, проверьте свою электронную почту, чтобы активировать учетную запись."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
  
    if @user.update(user_params)
      redirect_to root_path, notice: 'Данные пользователя обновлены!'
    else
      flash.now[:alert] = 'При попытке изменить пользователя возникли ошибки!'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    session.delete(:user_id)
    redirect_to root_path, notice: 'Пользователь удален!'
  end

  private

  def user_params
    params.require(:user).permit(
    :name, :nickname, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless user.present?
      flash[:error] = "Пожалуйста, зарегистрируйтесь на сайте"
      redirect_to :new
    end
  end
end
