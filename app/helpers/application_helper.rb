module ApplicationHelper
  def current_user
    if session[:user_id]
       User.find(session[:user_id])
    else
      nil
    end
  end

  def random_order
    db = Rails.configuration.database_configuration[Rails.env]["adapter"]
    Arel.sql(db == 'mysql2' ? "RAND()" : "RANDOM()")
  end
end
