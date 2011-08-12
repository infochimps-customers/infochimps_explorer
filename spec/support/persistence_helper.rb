def persist_records?
  # We have to introspect into super-classes because we might declare
  # 'persist_records!' in a 'describe' block which contains the block
  # in which this method is being evaluated.
  @persist_records || self.class.ancestors.any? { |c| c.instance_variable_get('@persist_records') }
end

def persist_records!
  @persist_records = true
  before(:all) do
    DatabaseCleaner.start
  end
  after(:all) do
    DatabaseCleaner.clean
    DatabaseCleaner.clean_elasticsearch
  end
end
