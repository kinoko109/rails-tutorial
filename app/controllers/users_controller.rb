class UsersController < ApplicationController
  def show
    puts "hoge@current_userddd"
    puts @current_user
    # puts
    @user = User.find(params[:id])
    # byebug gemのdebuggerメソッドを使うと、ターミナル上でリアルタイムでデバッグできる
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # save function
      redirect_to @user
      # redirect_to user_url(@user) と等価
    else
      render "new"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
