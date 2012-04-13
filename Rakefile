require 'rubygems'

desc "init env"
task :env do
  require File.join('.', 'config', 'env.rb')
end

namespace :db do

  desc "destructive bootstrap of the db"
  task :bootstrap => :env do
    DataMapper.auto_migrate!
    Rake::Task['heroku:load'].invoke
    Rake::Task['heroku:scrape'].invoke
  end

  desc "non-destructive migration of the db"
  task :migrate => :env do
    DataMapper.auto_upgrade!
  end
  
end

namespace :heroku do
  
  desc "Autoscale Dynos! Run every 10 minutes."
  task :autoscale => :env do
    Application.newrelic_enabled.each do |app| 
      puts "Autoscaling #{app.name}".yellow
      newrelic = Autoscale.new(app)
      newrelic.autoscale
    end
  end
  
  desc "Load your apps from heroku into the database. Run hourly."
  task :load => :env do
    h = Herokuni::API.new(confit.app.heroku.api_key)
    Yajl::Parser.new.parse(h.get_apps).each do |app|
      Application.create_from_heroku(app)
    end
    
  end
    
  desc "Scrape the Heroku config for each app. Run hourly."
  task :scrape => :env do
    Application.all.each do |app|
      app.scrape_heroku_config
    end
  end
  
  desc "Save a newrelic api key APP=app_name KEY=newrelic_api_key APP_ID=newrelic_app_id"
  task :add_new_relic_key => :env do
    app = Application.first(:name => ENV['APP'])
    app.new_relic_api_key = ENV['KEY']
    app.new_relic_app_id = ENV['APP_ID']
    app.save
    
    if app and app.saved?
      puts "Updated #{app.name}!".green
    else
      puts "Couldn't update #{app.name} :(".red
    end
    
  end
  
  desc "Delete an api key to stop autoscaling an app. APP=app_name"
  task :delete_new_relic_key => :env do
    app = Application.first(:name => ENV['APP'])
    app.new_relic_api_key = nil
    app.save
  end
  
end