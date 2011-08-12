class ApiCall < ActiveRecord::Base
  belongs_to :dataset
  
  serialize :request
  serialize :response
end