class User < ActiveRecord::Base
  devise :database_authenticatable, :encryptable, :rememberable, :trackable
  
  def self.current_user
    Thread.current[:user]
  end
  
  def self.current_user= new_user
    raise(ArgumentError, "The current_user must be an object of class User") unless (new_user.is_a?(User) || new_user.nil?)
    Thread.current[:user] = new_user
  end

  def self.logged_in?
    !! current_user
  end
  
  # is the current_user an admin?
  def self.is_admin?
    logged_in? && current_user.admin
  end
  
  def query_apikey
    self.authentication_token
  end
  
  def self.has_query_apikey?
    logged_in? && current_user.query_apikey.present?
  end
end
