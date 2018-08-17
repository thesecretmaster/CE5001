module CommentHelper
  def obscure_usernames(text, usermap:, post:)
    mentions = text.scan(%r{(\@[^\s]{3,})}).flatten
    post.comments.select do |comment|
      mentions.each do |mention|
        if mention[1..3].downcase == comment.commenter_name[0..2].downcase
          text.gsub!(mention, "@user#{usermap[comment.commenter_id]}")
        end
      end
    end
    text
  end
end
