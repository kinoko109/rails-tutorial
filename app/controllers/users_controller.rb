class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    # will_paginateメソッドにより、:pageは自動的に生成される
    @users = User.paginate(page: params[:page])
  end

  def show
    puts "hoge@current_userddd"
    puts @current_user
    # puts
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # byebug gemのdebuggerメソッドを使うと、ターミナル上でリアルタイムでデバッグできる
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント有効化に必要なメールを送信しました。"
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # save function
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
