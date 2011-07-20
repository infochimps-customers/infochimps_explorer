class ProtocolsController < ApplicationController
  def index
    @protocols = {}
    Dir[Rails.root + 'datasets/**/*.icss.*'].sort.each do |icss_filename|
      @protocols[File.basename(icss_filename)] = Icss::Protocol.receive_from_file(icss_filename)
    end
  end
  
  def show
    load_icss
  end
  
  def edit
    load_icss
    @types = (@icss.types.collect(&:name) + ::Icss::Type::VALID_TYPES.keys) if @icss
  end
  
  def update
    load_icss
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
      File.open(@icss_file, 'w'){|f| f.write(@icss.to_hash.send(:"to_#{format}")) } if ['json', 'yaml'].include?(format)
    end
  end
private
  def load_icss
    # FIXME: injection on params[:id]
    @icss_file = Dir[Rails.root + "datasets/#{params[:id]}.icss.*"].first
    @icss = Icss::Protocol.receive_from_file(@icss_file) if @icss_file
  end
  
end
