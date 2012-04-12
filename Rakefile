require 'rubygems'

desc "initialize environment"
task :env do
  require File.join('.', 'config', 'env.rb')
end

namespace :db do

  desc "DESTRUCTIVE bootstrap of the database"
  task :bootstrap => :env do
    puts "Bootstrapping database."
    DataMapper.auto_migrate!
  end

  desc "non-destructive migration of the database (e.g. rake db:migrate RACK_ENV=jo_dev)"
  task :migrate => :env do
    DataMapper.auto_upgrade!
  end
end
