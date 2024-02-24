module UsersHelper
  # 引数で渡されたuserのGravatar画像を返す
  # def gravatar_for(user, otion = { size: 80 })
  def gravatar_for(user, size: 80) # キーワード引数
    gravater_id =  Digest::MD5::hexdigest(user.email.downcase)
    gravater_url = "https://secure.gravatar.com/avatar/#{gravater_id}?s=#{size}"
    image_tag(gravater_url, alt: user.name, class: "gravater")
  end
end
