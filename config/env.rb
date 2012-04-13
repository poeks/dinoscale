require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

class App < ::Sinatra::Base
    
  #def self.development?; (environment.to_s =~ /dev/ ? true : false); end
  def self.configure(*envs, &block)
    yield self if envs.empty? || envs.include?(environment.to_sym) || (environment.to_s =~ /dev/ && envs.first.eql?(:development))
  end
  
  configure do
    #register Sinatra::Synchrony
    #Sinatra::Synchrony.overload_tcpsocket!
    
    set :root, File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..')
    set :public_folder, File.join(root, 'public')
    set :sessions, true
    set :static, true
    
    Dir.glob(File.join(root, 'lib', '**/*.rb')).each { |f| require f }
    Dir.glob(File.join(root, 'models', '**/*.rb')).each { |f| require f }

    use Rack::Session::Cookie
    register ::Sinatra::Flash

    require File.join(root, 'app')
    require File.join(root, 'helpers')

    helpers Helpers
    DataMapper.finalize
    
    confit File.join(root, 'config', 'app.yml') 
    
    Mail.defaults do
      delivery_method :smtp, {
        :address   => "smtp.sendgrid.net",
        :port      => 587,
        :domain    => confit.app.sendgrid.domain,
        :user_name => confit.app.sendgrid.username,
        :password  => confit.app.sendgrid.password,
        :authentication => 'plain',
        :enable_starttls_auto => true 
      }
    end
    
  end

  configure :production do
    DataMapper.setup :default, ENV['DATABASE_URL']
  end
  
  configure :development do
    DataMapper::Logger.new STDOUT, :debug
    DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[environment.to_s]
  end

end

NEWRELIC_HOST = 'https://heroku.newrelic.com'
HEROKU_ADDONS = 'https://addons.heroku.com'

