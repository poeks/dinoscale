class Application
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true, :length => 100
  property :dynos, Integer, :required => true
  property :workers, Integer, :required => true
  property :newrelic_enabled, Boolean, :required => true, :default => false
  property :newrelic_api_key, String
  
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

  property :created_at, DateTime, :index   => true
  property :updated_at, DateTime
  property :heroku_created_at, DateTime
  property :last_scraped_at, DateTime
  property :last_scaled_at, DateTime
  
  def self.by_dynos
    all(:order => :dynos.desc, :dynos.not => 0)
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