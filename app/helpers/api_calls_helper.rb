module ApiCallsHelper
  def api_call_response_documentation api_call
    haml_tag :ul do
      api_call.response['fields'].each do |sf|
        api_call_response_documentation_field(sf)
      end
    end
  end
  
  def api_call_response_documentation_field sf
    haml_tag :li do
      if sf['type'].is_a?(Array)
        haml_concat "<p>Exactly <b>one</b> of the following</b>.</p>"
        haml_tag :ul do
          sf['type'].each do |allowed_type|
            unless allowed_type.blank?
              api_call_response_documentation_field(allowed_type.values.first)
            end
          end
        end
      else
        haml_tag :span, h(sf['name']), :class => 'name'
        haml_tag :span, textilize_with_sanitize(sf['doc']), :class => 'doc clearfix'
      end
    end
  end
  
  def api_call_request_field_default(sf, samples)
    samples ? samples[sf["name"]] : sf['default']
  end
end
