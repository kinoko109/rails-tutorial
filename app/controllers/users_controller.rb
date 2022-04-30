class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 保存処理
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      # 対象のパラメーターだけを許可する（このように指定しないと他のパラメーターも受け付けてしまい脆弱性につながる）
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
