# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'ruby-progressbar'

Rails.application.load_tasks

namespace :csv do
  desc "TODO"
  task :import => :environment do
    # Get CSV from here: https://data.stackexchange.com/stackoverflow/query/872608?Fraction=150&Offset=0
    size = File.read("#{Rails.root}/QueryResults.csv").count("\n") - 1
    pb = ProgressBar.create(:title => "Importing...", total: size)
    CSV.foreach("#{Rails.root}/QueryResults.csv", headers: true) do |row|
      row = row.to_h
      post = Post.find_or_create_by(se_id: row['PostId'])
      post.update(post_type: row['PostTypeId'],
                  se_creation_date: DateTime.parse(row['PostCreationDate']),
                  poster_rep: row['PosterRep'],
                  title: row['Title'],
                  link: row['Post Link']
                )
      comment = post.comments.find_or_create_by(se_id: row['CommentId'])
      comment.update(body: row['Text'],
                     link: row['Comment Link'],
                     score: row['CommentScore'],
                     commenter_rep: row['CommenterRep'],
                     commenter_id: row['CommenterId'],
                     se_creation_date: DateTime.parse(row['CommentCreationDate']))
      pb.increment
    end
  end

  desc "TODO"
  task :dump => :environment do
    dump_time = DateTime.now
    things_to_include = {
      User => %w[id],
      CommentReview => %w[review_result_id id post_review_id],
      Comment => %w[body score id commenter_rep post_id],
      PostReview => %w[user_id post_id],
      Post => %w[body post_type id title poster_rep],
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
