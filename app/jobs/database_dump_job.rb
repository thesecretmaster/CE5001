class DatabaseDumpJob < ApplicationJob
  queue_as :default

  def perform(*args)
    dump_time = DateTime.now
    things_to_include = {
      User => %w[id],
      CommentReview => %w[review_result_id id post_review_id],
      Comment => %w[body score id se_id commenter_rep post_id],
      PostReview => %w[user_id post_id],
      Post => %w[body post_type id se_id title poster_rep],
      ReviewResult => %w[name id]
    }
    Dir.mkdir("#{Rails.root}/public/dumps") unless File.directory?("#{Rails.root}/public/dumps")
    Dir.mkdir("#{Rails.root}/public/dumps/#{dump_time}") unless File.directory?("#{Rails.root}/public/dumps/#{dump_time}")

    things_to_include.each do |model, attributes|
      pb = ProgressBar.create(:title => "Dumping #{model.to_s.pluralize}", total: model.count)
      csv_str = CSV.generate(headers: true) do |csv|
        csv << attributes

        model.all.each do |record|
          csv << attributes.map{ |attr| record.send(attr) }
          pb.increment
        end
      end
      File.write("#{Rails.root}/public/dumps/#{dump_time}/#{model.to_s.underscore.pluralize}.csv", csv_str)
    end
  end
end
