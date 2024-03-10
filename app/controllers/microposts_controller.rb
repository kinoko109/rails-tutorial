class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @miroposts = current_user.microposts.build(micropost_params)
    if @microposts.save
      flash[:success] = "マイクロポストを作成しました。"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
