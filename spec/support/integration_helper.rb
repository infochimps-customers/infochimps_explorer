module CapybaraSessionHelper
  def has_error? error_text
    has_css?('.errorExplanation') && within('.errorExplanation') { has_content?(error_text) }
  end

  def has_flash_error? error_text
    has_css?('#flash_error') && within('#flash_error') { has_content?(error_text) }
  end

  def has_flash_notice? notice_text
    has_css?('#flash_notice') && within('#flash_notice') { has_content?(notice_text) }
  end

  def has_object? obj
    has_css?("##{obj.class.to_s.tableize.singularize}_#{obj.id}")
  end

end
Capybara::Session.send(:include, CapybaraSessionHelper)

module CapybaraRSpecHelper
  def have_error error_text, options={}
    ::Capybara::RSpecMatchers::HaveMatcher.new(:error, error_text, options)
  end

  def have_flash_error error_text, options={}
    ::Capybara::RSpecMatchers::HaveMatcher.new(:flash_error, error_text, options)
  end

  def have_flash_notice notice_text, options={}
    ::Capybara::RSpecMatchers::HaveMatcher.new(:flash_notice, notice_text, options)
  end

  def should_be_logged_out
    page.should_not have_css('#current_user')
  end

  def should_be_logged_in_as user
    page.should have_css('#current_user')
    username = (user.respond_to?(:username) ? user.send(:username) : user)
    within('#current_user') do
      page.should have_content(username)
    end
  end

  def sign_in_with username, password
    visit login_path
    within("#user_new") do
      fill_in "Username", :with => username
      fill_in "Password", :with => password
    end
    click_button "Log in!"
  end

  def will options={}, &block
    expector = Expector.new(options)
    expector.set_expectations!
    yield
    expector.confirm_expectations!
  end

  def mock_search *results
    search = Search.new
    Search.stub!(:new).and_return(search)
    will_paginate_results = WillPaginate::Collection.new(1, 10, results.size)
    will_paginate_results.replace(results)
    search.should_receive(:perform).and_return(will_paginate_results)
    search
  end
  
end
Capybara::RSpecMatchers.send(:include, CapybaraRSpecHelper)
