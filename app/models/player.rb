class Player < ActiveRecord::Base
has_attached_file :photo, 
  :styles => {
    :thumb => "100x100#",
    :medium => "256x192" },
  :url => "/images/:id.:extension",
  :path => "#{CONFIG[:data_dir]}public/images/:id.:extension"

before_save :define_extraneous
 
  def define_extraneous
    username = self.email.split("@").first
    self.username = username
  end
   
  def to_param
    self.username  
  end

end
