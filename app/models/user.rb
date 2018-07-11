class User < ApplicationRecord
  has_many :post_reviews

  def get_username(api_token)
    if api_token.nil?
      Rails.logger.error 'User#get_username called without api_token or readonly_api_token'
      Rails.logger.error caller.join("\n")
      return
    end

    begin
      se = Rails.application.credentials[:SE]
      auth_string = "key=#{se[:api_key]}&access_token=#{api_token}"

      resp = Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=1&filter=!ms3d6aRI6N&#{auth_string}"))
      resp = JSON.parse(resp.body)

      first_site = URI.parse(resp['items'][0]['site_url']).host

      resp = Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me?site=#{first_site}&filter=!-.wwQ56Mfo3J&#{auth_string}"))
      resp = JSON.parse(resp.body)

      return resp['items'][0]['display_name']
    rescue => ex
      Rails.logger.error "Error raised while fetching username: #{ex.message}"
      Rails.logger.error ex.backtrace
    end
  end
end
