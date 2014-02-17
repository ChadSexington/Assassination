class NewsPost < ActiveRecord::Base
  attr_accessible :body, :public, :title
end
