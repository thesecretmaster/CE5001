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
                     se_creation_date: DateTime.parse(row['CommentCreationDate']))
      pb.increment
    end
  end
end
