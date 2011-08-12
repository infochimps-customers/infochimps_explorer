class ProtocolsController < ApplicationController
  before_filter :admin_only, :only => [:index, :show, :new, :create, :edit, :update]
  
  def index
    @protocols = {}
    Dir[Rails.root + 'datasets/**/*.icss.*'].sort.each do |icss_filename|
      @protocols[File.basename(icss_filename)] = Icss::Protocol.receive_from_file(icss_filename)
    end
    render :layout => !params[:layoutless]
  end
  
  def show
    load_from_path
  end
  
  def documentation
    load_from_cached_slug    
    respond_to do |format|
      format.esi { render :documentation, :layout => false }
    end
  end
  
  def explorer
    load_from_cached_slug
    respond_to do |format|
      format.esi { render :explorer, :layout => false }
    end
  end
  
  def new
    template = {
      :protocol => 'Untitled',
      :types => [{
        :name => 'Untitled',
        :type => :record,
        :fields => [{
          :type => :string,
          :name => 'Untitled'
        }]
      }],
      :messages => {
        'Untitled' => {
          'name' => 'Untitled',
          'request' => [{ 'name' => 'string', 'type' => 'string' }],
          'response' => "string" }
      }
    }
    @icss = Icss::Protocol.receive(template)
    @types = (@icss.types.to_a.collect(&:name) + ::Icss::Type::VALID_TYPES.keys) if @icss
    render :layout => !params[:layoutless]
  end
  
  def create
    
    @messages = params[:protocol].delete :messages
    params[:protocol][:messages] = @messages.inject({}){ |hash, msg| hash.merge!(msg[:name] => msg) }
    params[:protocol][:messages].each do |name, msg| 
      msg[:request][0][:name] = msg[:request][0][:type]
      msg[:samples].collect!{ |sample| JSON.parse(sample) rescue nil }.compact  
    end
    
    @icss = Icss::Protocol.receive(params[:protocol])
    
    # create directory structure based on namespace
    # save yaml file
    file = Rails.root + File.join(@icss.namespace.match(/\A[a-z0-9_-]+(\.[a-z0-9_-]+)*\Z/i).to_s.split('.').unshift('datasets') << (@icss.protocol+'.icss.yaml'))
    file.descend {|path| Dir.mkdir(path) unless File.exists?(path) || path.to_s.match(/\./)}
    File.open(file, (File::WRONLY|File::CREAT|File::EXCL)){|f| f.write(recursive_stringify_keys(@icss.to_hash).to_yaml) }
    
    redirect_to protocol_path(@icss.path)
  end
    
  
  def edit
    load_from_path
    @types = (@icss.types.to_a.collect(&:name) + ::Icss::Type::VALID_TYPES.keys) if @icss
    
    render :layout => !params[:layoutless]
  end
  
  def update
    load_from_path
    if @icss
      # empty icss types and message, so they can be recreated
      @icss.types = @icss.messages = []
      
      # rearrange params hash to conform with icss protocol
      @messages = params[:protocol].delete :messages
      params[:protocol][:messages] = @messages.inject({}){ |hash, msg| hash.merge!(msg[:name] => msg) }
      params[:protocol][:messages].each do |name, msg| 
        msg[:request][0][:name] = msg[:request][0][:type]
        msg[:samples].collect!{ |sample| JSON.parse(sample) rescue nil }.compact  
      end
      
      # merge existing icss with params
      @icss = Icss::Protocol.receive @icss.tree_merge!(params[:protocol])
      
      # write icss to existing file
      format = File.extname(@icss_file).gsub(/\./, '')
      File.open(@icss_file, 'w'){|f| f.write(recursive_stringify_keys(@icss.to_hash).send(:"to_#{format}")) } if ['json', 'yaml'].include?(format)
    end
    render :layout => !params[:layoutless]
  end
private
  def admin_only
    redirect_to(root_url) unless User.is_admin?
  end

  def recursive_stringify_keys(obj)
    if obj.is_a?(Hash)
      obj.each{ |key, value| obj[key] = recursive_stringify_keys(value) if (value.is_a?(Hash) || value.is_a?(Array)) }
      obj.stringify_keys
    elsif obj.is_a?(Array)
      obj.collect!{ |item| (item.is_a?(Hash) && recursive_stringify_keys(item)) || item } if obj.is_a?(Array)
    else
      obj
    end
  end
  
  def load_from_cached_slug
    @dataset = Dataset.find_by_cached_slug params[:slug]
    @icss = @dataset.icss if @dataset
  end

  def load_from_path
    # FIXME: injection on params[:id]
    path = params[:id].match(/\A[a-z0-9_-]+(\/[a-z0-9_-]+)*\Z/i).to_s.split('/')
    path.push(path.pop + '.icss.*')
    @icss_file = Dir[Rails.root + File.join(path.unshift 'datasets')].first
    @icss = Icss::Protocol.receive_from_file(@icss_file) if @icss_file
  end
  
end
