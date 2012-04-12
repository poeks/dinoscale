require 'rubygems'

desc "init env"
task :env do
  require File.join('.', 'config', 'env.rb')
end

namespace :db do

  desc "destructive bootstrap of the db"
  task :bootstrap => :env do
    DataMapper.auto_migrate!
  end

  desc "non-destructive migration of the db"
  task :migrate => :env do
    DataMapper.auto_upgrade!
  end
  
end

namespace :heroku do
  
  desc "load your apps from heroku into the database"
  task :load => :env do
    h = Herokuni::API.new(confit.app.heroku.api_key)
    puts h.get_apps.inspect
  end
  
end