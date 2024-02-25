class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    # will_paginateメソッドにより、:pageは自動的に生成される
    @users = User.paginate(page: params[:page])
  end

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新成功処理
      flash[:success] = "プロフィール画像を変更しました。"
      puts "updateしました"
      puts @user
      redirect_to @user
    else
      render "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # beforeアクション
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
