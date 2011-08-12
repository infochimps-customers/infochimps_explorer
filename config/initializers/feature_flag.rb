module FeatureFlag
  def active_feature?(feature)
    Settings[:feature_flag][feature.to_sym]
  end
end

[ActiveRecord::Base, ActionController::Base, ActionView::Base].each do |klass|
  klass.send(:include, FeatureFlag)
  klass.send(:extend,  FeatureFlag)
end