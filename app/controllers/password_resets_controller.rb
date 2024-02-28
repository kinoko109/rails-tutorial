class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only[:edit, :update]
  # パスワード再設定の有効期限が切れていないか
  before_action :check_expiration, only[:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定のリンクをメールで送信しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが見つかりません。"
      render "new"
    end
  end

  def edit

  end

  def update
    if params[:user][:password].empty? # 新しいパスワードが空文字列になっていないか
      @user.errors.add(:password, :blank)
      render "edit"
    elsif @user.update(user_params) # 新しいパスワードが正しければ、更新
      log_in @user
      flash[:success] = "パスワードをリセットしました。"
      redirect_to @user
    else
      # 無効なパスワードであれば失敗させる（失敗した理由も表示する）
        render "edit"
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params["email"])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash["danger"] = "パスワードリセットの期限が切れています。"
        redirect_to new_password_reset_url
      end
    end

end
