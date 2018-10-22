class RestockCommentsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    last_restock_time = get_restock_time
    return if Time.now.to_i - last_restock_time.to_i < 120
    # restock the cache
  end

  private

  def get_restock_time
    Rails.cache.fetch("comments/last_restock_time") do
      Time.now.to_i
    end
  end
end
