class NewsPost < ActiveRecord::Base
  attr_accessible :body, :hidden, :title
end
