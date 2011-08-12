class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :store_request_context
  def store_request_context
    @action     ||= request.params[:action]
    @rsrc_type  ||= request.params[:controller]
    User.current_user = current_user # enables User.current_user type methods in app/models/user.rb
  end
end
