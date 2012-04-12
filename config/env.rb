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

    Dir.glob(File.join(root, 'lib', '**/*.rb')).each { |f| require f }
    Dir.glob(File.join(root, 'models', '**/*.rb')).each { |f| require f }

    use Rack::Session::Cookie
    register ::Sinatra::Flash

    require File.join(root, 'app')
    require File.join(root, 'helpers')

    helpers Helpers
    DataMapper.finalize
    
    confit File.join(root, 'config', 'app.yml') 
  end

  configure :production do
    DataMapper.setup :default, ENV['DATABASE_URL']
  end
  
  configure :development do
    DataMapper::Logger.new STDOUT, :debug
    DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[environment.to_s]
  end

end

