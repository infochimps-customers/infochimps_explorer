class Endpoint
  # Block chain for preparing handler params
  PREPARERS  = Hash.new{|h,k| h[k] = [] }
  # Block chain for preparing handler params
  FINALIZERS = Hash.new{|h,k| h[k] = [] }
  PROTOCOL_SCHEMAS = {}

  class_inheritable_accessor :precooked_response_type
  self.precooked_response_type = nil

  class << self # evaluate in class context

    #
    # With :dump_icss_on_load set to true in the config/apeyeye.yaml, this
    # summarizes each icss file as it is brought in.
    #
    def dump_handler message, message_path, protocol
      return unless Settings.dump_icss_on_load
      if protocol.blank? then warn  "!!!! Null protocol for #{message_path}" ; return ; end
      begin
        puts [
          "#{message_path}:\n  #{protocol.inspect}",
          protocol.messages[message].inspect,
          protocol.types.map{|t| t.inspect rescue nil },
        ].join("\n  - ")+"\n  ."
      rescue Exception => e
        warn "Error in ICSS #{message_path}: #{e}"
        warn protocol.inspect
      end
    end

    #
    # Protocol
    #
    def namespace
      protocol.namespace
    end

  end
end
