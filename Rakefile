require 'rubygems'

desc "init env"
task :env do
  require File.join('.', 'config', 'env.rb')
end

namespace :db do

  desc "destructive bootstrap of the db"
  task :bootstrap => :env do
    puts "Bootstrapping database."
    DataMapper.auto_migrate!
  end

  desc "non-destructive migration of the db"
  task :migrate => :env do
    DataMapper.auto_upgrade!
  end
  
end
