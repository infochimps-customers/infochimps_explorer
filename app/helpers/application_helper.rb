module ApplicationHelper
  require 'icss/view_helper'
  
  def ssi_tag path
    path = '/' + path unless path.starts_with?('/')
    %Q{<!--# include virtual="#{path}" -->}.html_safe
  end
  
  def title(page_title, show_title = true, override_main = false)
    @content_for_title = page_title.to_s
    @show_title = show_title
    @override_main =  override_main
  end
  
  def george_url *args
    File.join("http://" + Settings[:host], *args)
  end
  
  def api_explorer_url *args
    File.join("http://" + Settings[:api_explorer_host], *args)
  end

  def user_apikey_or_default
    (User.logged_in? && User.current_user.query_apikey) || Settings[:default_api_key]
  end
end
