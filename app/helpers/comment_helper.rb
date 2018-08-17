module CommentHelper
  def obscure_usernames(text, usermap:, post:)
    mentions = text.scan(%r{(\@[^\s]{3,})}).flatten
    post.comments.select do |comment|
      mentions.each do |mention|
        if mention[1..3].downcase == comment.commenter_name.to_s.gsub(' ', '')[0..2].downcase
          text.gsub!(mention, "@user#{usermap[comment.commenter_id] || 'NA'}")
        end
      end
    end
    text
  end

  def render_md_s(text)
    a = code_block_split(text)
    p a
    a.map { |i| sanitize i }
  end

  def render_md(text)
    #text = text.split(%r{\`{1,}}).reject(&:empty?).map.with_index do |segment, index|
    text = code_block_split(text).map.with_index do |segment, index|
      segment = CGI::escapeHTML segment
      segment = sanitize segment
      if text[0] == '`' && index % 2 == 0
        "<code>#{md_html_escape segment}</code>"
      elsif text[0] != '`' && index % 2 == 1
        "<code>#{md_html_escape segment}</code>"
      else
        segment = segment.gsub(%r{\[([^\]]*)\]\((http[^\)]*)\)}, '<a href="\2">\1</a>')
        segment = segment.gsub(%r{\[([^\]]*)\]\((\/[^\)]*)\)}, '<a href="https://stackoverflow.com\2">\1</a>')
        segment = segment.gsub(%r{(^|[^\"])(http[^\b\s]*{5,})}) do
          link = Regexp.last_match[2]
          link_short = link.gsub(%r{^https?\:\/\/}, '')[0..55]+'...'
          " <a href=\"#{link}\">#{link_short}</a>"
        end
        segment = segment.gsub('[edit]', '<a href="#">edit</a>')
        segment = segment.gsub(%r{\[tag\:([a-zA-Z\-]{1,})\]}, '<a href="https://stackoverflow.com/questions/tagged/\1">\1</a>')
        segment = segment
      end
    end.join
    text = text.gsub(%r{\*\*([^\*]*)\*\*}, '<b>\1</b>')
    text = text.gsub(%r{\_\_([^\_]*)\_\_}, '<b>\1</b>')
    text = text.gsub(%r{\*([^\*]*)\*}, '<i>\1</i>')
    text = text.gsub(%r{\_([^\_]*)\_}, '<i>\1</i>')
  end

  private

  def md_html_escape(text)
    text = text.gsub('*', '&#42;')
    text = text.gsub('_', '&#95;')
    text
  end

  def code_block_split(text, logging: false)
    idx = 0
    arr = []
    backticks = 0
    i = 0
    loop do
      break if i == text.length
      char = text[i]
      arr[idx] ||= []
      if char != '`'
        puts "#{char}: Not a backtick; appending" if logging
        arr[idx] << char
        i += 1
      elsif backticks == 0
        q = i
        q += 1 while text[q] == '`'
        backticks = q-i
        puts "#{char}: Hit a backtick; eating #{text[i..i+backticks]}" if logging
        i += backticks
        idx += 1
      else
        q = i
        q += 1 while text[q] == '`' && q-i <= backticks
        if q-i < backticks
          puts "#{char}: Backtick false alarm; skipping ahead" if logging
          (q-i).times do
            arr[idx] << char
            i += 1
          end
        else
          puts "#{char}: Hit a close backtick; eating #{text[i..i+backticks]}" if logging
          i+= backticks
          backticks = 0
          idx += 1
        end
      end
    end
    arr.map(&:join).reject(&:empty?)
  end
end
