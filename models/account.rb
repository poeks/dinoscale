require 'digest/sha1'

class Account

  include DataMapper::Resource
      
  property :id, DataMapper::Property::Serial, :index => true  
  property :email, String, :required => true, :unique => true, :length => 100,
      :messages => {
        :presence  => 'We need your email address.',
        :is_unique => 'We already have that email.',
      }
  property :password_hash, String, :required => false, :length => 255
  property :password_salt, String, :required => false, :length => 255
  property :created_at, DateTime, :index => true
  property :updated_at, DateTime

  attr_accessor :password
      
  before :save do
    set_password
  end
      
  before :create do
    set_password
  end
  
  def self.authorized?(session)
    false
  end

  def set_password
    if self.password and not self.password.empty?
      self.generate_password_salt if not self.password_salt
      self.encrypt_password
    end
  end
  
  def random_password
    rand(36**12).to_s(36)
  end
  
  def generate_password_salt
    self.password_salt = OpenSSL::Random.random_bytes(50).unpack('H*')
  end

  def compare_password(password)
    inputted_password = Digest::SHA1.hexdigest("#{password}#{self.password_salt}")
    inputted_password==self.password_hash
  end
  
  def encrypt_password
    self.password_hash = Digest::SHA1.hexdigest("#{self.password}#{self.password_salt}")
  end

  def session_id
    self.class.to_s + '|' + id.to_s
  end

  def self.from_session_id(sid)
    klass, sid = sid.split '|'
    klass = Kernel.const_get(klass)
    klass.get sid
  end
  
  def self.from_email(email)
    self.first(:email => email)
  end

end
