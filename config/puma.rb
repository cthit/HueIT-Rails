# config/puma.rb
threads 1,16
workers 2
preload_app!

port ENV['PORT'] || 3000
environment ENV['RAILS_ENV'] || 'development'

on_worker_boot do
  # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
  ActiveRecord::Base.establish_connection
end
