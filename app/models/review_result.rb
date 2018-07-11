class ReviewResult < ApplicationRecord
  has_many :comment_reviews

  def emoji_or_fallback(**opts)
    return emoji if emoji.length <= 1
    raw("<img width='23px' height='23px' src=\"#{sanitize(emoji)}\" #{opts.map { |k, v| "#{sanitize(k)}=\"#{sanitize(v)}\""}.join(' ')}>")
  end

  private

  def sanitize(str)
    ActionController::Base.helpers.sanitize(str.to_s)
  end

  def raw(str)
    ActionController::Base.helpers.raw(str.to_s)
  end
end
