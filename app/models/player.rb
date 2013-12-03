class Player < ActiveRecord::Base

# This defines the photo attachment.
# DO NOT change the url and path. Took hours to get this right and it corelates with many other places in the code
has_attached_file :photo, 
  :styles => {
    :thumb => "100x100#",
    :medium => "256x192" },
  :url => "/images/:id.:extension",
  :path => "#{CONFIG[:data_dir]}public/images/:id.:extension"

# Validations to ensure uniqeness and... stuff
validates_uniqueness_of :email, :name
validates_length_of :name, :within => 3..30
validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

# Before the initial save, set attributes defined using other attributes
before_save :define_extraneous
 
  def define_extraneous
    username = self.email.split("@").first
    self.username = username
  end
 
# use the username in the url instead of some integer id 
  def to_param
    self.username  
  end

end
