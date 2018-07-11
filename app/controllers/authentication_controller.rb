class AuthenticationController < ApplicationController
  def login; end

  def begin_oauth
    se = Rails.application.credentials[:SE]
    redirect_to "https://stackoverflow.com/oauth?client_id=#{se[:client_id]}&redirect_uri=#{end_oauth_url}"
  end

  def end_oauth
    se = Rails.application.credentials[:SE]
    resp = HTTParty.post("https://stackoverflow.com/oauth/access_token/json", body: {
      client_id: se[:client_id],
      client_secret: se[:client_secret],
      code: params[:code],
      redirect_uri: end_oauth_url
    })
    resp = JSON.parse(resp.body)
    if resp['access_token']
      account_id = JSON.parse(HTTParty.get("https://api.stackexchange.com/2.2/access-tokens/#{resp['access_token']}?key=#{se[:api_key]}").body)["items"][0]["account_id"]
      user = User.find_or_create_by(se_id: account_id)
      session[:user_id] = user.id
      redirect_to comment_path
    else
      redirect_to login_path
    end
  end

  def logout
    session.clear
    redirect_to login_path
  end
end
