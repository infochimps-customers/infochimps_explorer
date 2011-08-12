module IcssHelper
  def reference_to_type type, options={}
    return "[unspecified]" if type.blank?
    case
    when type.is_a?(Array)
      type.map{|subtype| reference_to_type(subtype, :shallow => true) }.join(" | ")
    when options[:shallow]
      (type.respond_to?(:title) ? h(type.title) : h(type.inspect) )
    when type.is_a?(Icss::ArrayType)
      %Q{array of #{reference_to_type(type.items)}}
    when type.is_a?(Icss::MapType)
      %Q{map of #{reference_to_type(type.values)}}
    when type.is_a?(Icss::FixedType)
      %Q{#{h(type.title)}: #{type.size.to_i}-byte fixed field}
    when type.is_a?(Icss::EnumType)
      %Q{#{h(type.title)}: #{type.symbols.inspect}}
    when type.is_a?(Icss::NamedType)
      %Q{<a href="#type-#{h(type.name)}">#{h(type.title)}</a>}
    else
      (type.respond_to?(:title) ? h(type.title) : h(type.inspect) )
    end
  end
end