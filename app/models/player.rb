class Player < ActiveRecord::Base

attr_accessor :password, :password_confirmation
has_many :assignments
has_many :kills
has_many :deaths

# This is necessary for authentication stuffs
require 'digest/sha1'

# This defines the photo attachment.
# DO NOT change the url and path. Took hours to get this right and it correlates with many other places in the code
has_attached_file :photo, 
  :styles => {
    :thumb => "200x260",
    :card => "140x160" },
  :url => "/images/:id.:extension",
  :path => "#{CONFIG[:data_dir]}public/images/:id.:extension"

# Validations to ensure uniqeness and... stuff
validates_uniqueness_of :email, :name, :irc_nick
validates_length_of :name, :within => 3..30
validates_length_of :password, :within => 5..30, :if => :password_validation_required?
validates_confirmation_of :password
validates_length_of :notes, :within => 0..250
validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
validates_presence_of :email, :name, :irc_nick, :photo
validates_presence_of :password, :password_confirmation, :salt, :if => :password_validation_required?

# Before the initial save, set attributes defined using other attributes
before_save :define_username
before_save :define_nickname
before_save :check_admin
before_save :generate_confirmation_code

  def password=(pass)
    @password=pass
    self.salt = random_string(10) if not self.salt
    self.hashed_password = Player.encrypt(@password, self.salt)
  end

  # Pass a login and password. This will then search the database for the login
  # And then check the password to be sure it is correct
  #
  # If it is correct, it will RETRUN THE PLAYER
  #
  # if it is incorrect, it will RETURN NIL
  def self.authenticate(email, pass)
    player = find(:first, :conditions => ["email = ?", email])
    return nil if not player
    return player if Player.encrypt(pass, player.salt) == player.hashed_password
  end

  def password_validation_required?
    hashed_password.blank? || !@password.blank?
  end

  def define_username
    username = self.email.split("@").first
    self.username = username
  end

  def define_nickname
    nickname = self.name.split(" ").first
    self.nickname = nickname
  end

  def check_admin
    if self.email == CONFIG[:admin_email]
      self.admin = true
    end
  end
  
  def generate_confirmation_code
    self.confirmation_code = random_string(8)
  end
 
# use the username in the url instead of some integer id 
  def to_param
    self.username  
  end

private
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newstr = ""
    1.upto(len) { |i| newstr << chars[rand(chars.size-1)] }
    return newstr
  end

end
