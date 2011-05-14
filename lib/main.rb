class Main < Sinatra::Base

  set :dump_errors,      Proc.new{ not production? }
  set :logging,          true
  set :methodoverride,   true
  set :raise_errors,     Proc.new{ test? }
  set :root,             ROOT_DIR.path
  set :run,              Proc.new{ $0 == app_file }
  set :show_exceptions,  Proc.new{ development? }
  set :views,            ROOT_DIR.path("app", "views")
  configure :production do
    set :static,         false
  end
  configure :development, :test do
    set :static,         true
    set :clean_trace,    true
  end

  # configure(:development, :test) do
  #   require "ruby-debug"
  # end

  helpers do
    def render_partial(options = {})
      raise "please specify a partial: render_partial :partial => 'hi_mom'" unless options[:partial]
      template = options.delete(:partial)
      locals   = options.delete(:locals) || {}
      haml(template, options, locals)
    end

    def haml(template, options = {}, locals = {})
      options[:escape_html] = false unless options.include?(:escape_html)
      super(template, options, locals)
    end

    def partial(template, locals = {})
      haml(template, {:layout => false}, locals)
    end

    %w[environment production? development? test? staging? ].each do |meth|
      define_method(meth) { |*a| self.class.send(meth, *a) }
    end
  end
  def self.staging?;  environment == :staging  end
end
