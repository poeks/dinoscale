class Application
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :dynos, Integer, :required => true
  property :workers, Integer, :required => true
  property :newrelic_enabled, Boolean, :required => true, :default => false
  
  property :created_at, DateTime, :index   => true
  property :updated_at, DateTime
  
end