class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # byebug gemのdebuggerメソッドを使うと、ターミナル上でリアルタイムでデバッグできる
    # debugger
  end

  def new
  end
end
