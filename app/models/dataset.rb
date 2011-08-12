class Dataset< ActiveRecord::Base
  has_many :api_calls
  
  def api_call
    @api_call ||= api_calls.order("created_at DESC").first
  end
  
  def icss
    return if raw_icss.blank?
    begin
      @icss ||= Icss::Protocol.receive_yaml(raw_icss)
    rescue Exception => e
      Rails.logger.info [e, raw_icss[0..1000]]
      return nil
    end
  end
  
  def samples
    begin
     objects = @icss.messages.keys
     sample = {}
     # I wasn't sure if the sample data will always be in a specific geo_location_infochimps_[place | path | event] so I loop
     # through each one of them until sample data is found then I break out of the loop. If sample data will always be found in one location
     # we can get rid of the loop.
     
     objects.each do |object|
      sample = @icss.messages[object].samples.first.request.first if @icss.messages[object].samples && @icss.messages[object].samples.first.request
      break if sample
     end
     return sample
    rescue
      return nil
    end
  end
  
  def is_a_geo?
    # there doesn't appear to be a good geo flag for the 13 datasets that have good geo samples, so we're checking manually
    # I'm thinking it might be better for the array to be an array of names so it's more descriptive.
    geos = [20869, 20853, 21039, 2283, 19416, 21040, 21051, 21086, 21135]
    geos.include? self[:id]    
  end
end