module TextileHelper
  def api_call_textilize_doc obj
    case
    when obj.is_a?(Hash)
      obj['doc'] = api_call_textilize_doc(obj['doc']) if obj['doc'].present?
      obj.keys.each do |key|
        value = obj[key]
        if value.is_a?(Hash) || value.is_a?(Array)
          obj[key] = api_call_textilize_doc(value)
        end
      end
    when obj.is_a?(Array)
      obj.map! { |element| api_call_textilize_doc(element) }
    when obj.is_a?(String)
      obj = textilize_truncated_text(obj, :max_len => 255)
    end
    obj
  end
  
  def textilize_with_sanitize text, &block
    return "" if text.blank?
    textilized = RedCloth.new(text, [:sanitize_html, :filter_classes, :filter_ids, :filter_styles])
    if block_given?
      textilized.to_html.html_safe+ yield
    else
      textilized.to_html.html_safe
    end
  end
  
  def textilize_truncated_text text, options={}
    text = text.to_s ; return '' if text.blank?
    options = options.reverse_merge :ellipsis => '...', :link => nil, :max_len => 255
    max_len = options[:max_len]
    if text.length < max_len
      text     = text
    else
      text     = text[ 0 .. (max_len - options[:ellipsis].length) ].gsub(/\s+\z/m,'')
      ellipsis = '&nbsp;'+options[:ellipsis].to_s
      text    += textiled_link(ellipsis, options[:link])
    end
    textilize_with_sanitize text
  end
end
