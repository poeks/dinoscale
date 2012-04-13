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
    
    h.get_apps.each do |app|
      Application.create_from_heroku(app)
    end
    
  end
  
  desc "test2"
  task :test => :env do
    response = Curl::Easy.perform("https://rpm.newrelic.com/accounts/100101/applications.xml") do |curl| 
        curl.headers["x-api-key"] = ""
    end
    puts response.body_str
  end
  
  desc "test"
  task :newrelicify => :env do
    #/apps/:app/config_vars
    app = Application.first(:name => ENV['APP']) or (puts "No app! Do APP=blah";exit)
    h = Herokuni::API.new(confit.app.heroku.api_key)
    puts h.get_apps(app.name, 'config_vars')
    
  end
  
  desc "save a newrelic api key APP=scg-blah-yadda KEY=newrelic_api_key"
  task :add_newrelic_key => :env do
    app = Application.first(:name => ENV['APP'])
    app.newrelic_api_key = ENV['KEY']
    app.newrelic_enabled = true
    app.save
    
    if app and app.saved?
      puts "Updated #{app.name}!".green
    else
      puts "Couldn't update #{app.name} :(".red
    end
    
  end
  
  
end