module ControllerSpecHelper

  include Devise::TestHelpers

  def as user
    @as = user
  end

  def i_request params={}
    @verb   = params.delete(:verb)   if params[:verb]
    @action = params.delete(:action) if params[:action]
    @params = params
  end

  def i_receive options={}
    controller_spec(@verb, @action, options.merge((@params || {})).merge(:as => @as))
  end
  
  def controller_spec verb, action, options={}
    #
    # Set Expectations
    #
    user = options.delete(:as)
    if user
      sign_in(user)
      sign_in(user)
    else
      sign_out(:user)
    end

    render_template = options.delete(:render)
    redirect_url    = options.delete(:redirect)
    raise "Cannot provide both :render and :redirect in a controller spec" if render_template && redirect_url

    case
    when options.has_key?(:status)
      status = options.delete(:status)
    when redirect_url
      status = 302
    else
      status = 200
    end
    
    expector = Expector.new(options)
    expector.set_expectations!
    
    #
    # Perform Request
    #

    send(verb, action, options)

    #
    # Check expectations
    #

    expector.confirm_expectations!
    
    case
    when render_template
      response.should render_template(render_template)
    when redirect_url
      case
      when redirect_url.is_a?(Hash)
        klass  = redirect_url.keys.first.to_s.classify.constantize
        method = redirect_url[redirect_url.keys.first]
        response.should redirect_to(klass.send(method))
      when redirect_url.is_a?(Regexp)
        response.redirect_url.should =~ redirect_url
      else
        response.should redirect_to(redirect_url)
      end
    end

    response.code.to_i.should == status if status
    
  end

end
