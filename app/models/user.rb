class User < ApplicationRecord
  has_many :post_reviews

  def get_user_metadata(api_token)
    if api_token.nil?
      Rails.logger.error 'User#get_username called without api_token or readonly_api_token'
      Rails.logger.error caller.join("\n")
      return
    end

    begin
      se = Rails.application.credentials[:SE]
      auth_string = "key=#{se[:api_key]}&access_token=#{api_token}"

      filter = "!6PCcoH3L)RrNC"
      resp = Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=100&filter=#{filter}&#{auth_string}"))
      items = JSON.parse(resp.body)['items']
      resp = Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=100&page=2&filter=#{filter}&#{auth_string}"))
      items << JSON.parse(resp.body)['items']
      Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=100&page=3&filter=#{filter}&#{auth_string}"))
      items << JSON.parse(resp.body)['items']
      items.reject!(&:empty?)

      Rails.logger.info "https://api.stackexchange.com/2.2/me/associated?pagesize=100&filter=!ms3d6aRI6N&#{auth_string}"
      first_site = URI.parse(items[0]['site_url']).host

      roles = %w[does_not_exist unregistered registered team_admin moderator staff]
      user_type = roles[0]
      reputation = 0
      question_count = 0
      answer_count = 0
      Rails.logger.info "Got #{items.length} sites; #{items}"
      items.each do |site|
        Rails.logger.info site
        user_type = site['user_type'] if roles.index(site['user_type']).to_i > roles.index(user_type).to_i
        reputation += site['reputation'].to_i
        question_count += site['question_count'].to_i
        answer_count += site['answer_count'].to_i
      end

      resp = Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me?site=#{first_site}&filter=!-.wwQ56Mfo3J&#{auth_string}"))
      resp = JSON.parse(resp.body)

      username = resp['items'][0]['display_name']
      return { username: username, user_type: user_type, reputation: reputation, question_count: question_count, answer_count: answer_count }
    rescue => ex
      Rails.logger.error "Error raised while fetching user information: #{ex.message}"
      Rails.logger.error ex.backtrace
    end
  end
end
