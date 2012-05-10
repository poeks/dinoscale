class Application
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 100
  property :dynos, Integer, :required => true
  property :workers, Integer, :required => true
  property :new_relic_api_key, String
  
  property :domain_name, String, :length => 255
  property :repo_migrate_status, String
  property :stack, String
  property :slug_size, Integer
  property :requested_stack, String
  property :web_url, String
  property :git_url, String
  property :heroku_id, Integer
  property :buildpack_provided_description, String
  property :repo_size, Integer
  property :owner_email, String
  property :create_status, String

  property :database_url, String, :length => 255
  property :new_relic_app_name, String
  property :new_relic_license_key, String
  property :new_relic_log, String
  property :new_relic_id, String
  property :new_relic_app_id, String
  property :commit_hash, String
  property :last_git_by, String
  property :rack_env, String
  property :lang, String

  property :created_at, DateTime, :index   => true
  property :updated_at, DateTime
  property :heroku_created_at, DateTime
  property :last_scraped_at, DateTime
  property :last_scaled_at, DateTime
  
  cattr_accessor :herokuni
  
  def self.get_herokuni
    self.herokuni ||= Herokuni::API.new(confit.app.heroku.api_key)
  end

  def self.newrelic_enabled
    all(:order => :dynos.desc, :new_relic_app_name.not => nil, :new_relic_api_key.not => nil)
  end

  def self.newrelic_notenabled
    all(:order => :dynos.desc, :new_relic_app_name.not => nil, :new_relic_api_key => nil)
  end

  def self.other
    all(:order => :dynos.desc, :new_relic_app_name => nil, :new_relic_api_key => nil)
  end
  
  def scrape_heroku_config
    self.class.get_herokuni
    body = self.class.herokuni.get_apps(self.name, 'config_vars')
    hash = Yajl::Parser.new.parse body
    
    hash.each_pair do |key, value|
      if self.respond_to?(key.downcase)
        self.send("#{key.downcase}=", value)
      end
    end
    
    puts self.errors.inspect.red if !self.valid?
    self.last_scraped_at = DateTime.now
    self.save
    self
  end
  
  def self.create_from_heroku(hash)
    heroku_id = hash.delete("id")
    created = hash.delete("created_at")

    app = self.first_or_new(:heroku_id => heroku_id)
    app.attributes = hash
    app.heroku_created_at = created
    
    puts app.errors.inspect.red if !app.valid?
    app.save
    app
  end
  
end