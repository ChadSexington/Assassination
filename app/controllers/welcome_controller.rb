class WelcomeController < ApplicationController
  def index
  end
  
  def about
    contents = File.open("#{Rails.root}/config/ABOUT.md", "r").read 
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :strikethrough => true, :fenced_code_blocks => true, :underline => true, :quote => true, :footnotes => true)
    @contents = markdown.render(contents)
  end

  def central
    @kills = Kill.order('created_at DESC').limit(20).all
    @kill = Kill.new
    @players = Player.where(:confirmed => true)
  end

end
