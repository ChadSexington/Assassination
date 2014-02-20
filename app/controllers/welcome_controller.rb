class WelcomeController < ApplicationController
  def index
  end
  
  def about
    contents = File.open("#{Rails.root}/config/ABOUT.md", "r").read 
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :strikethrough => true, :fenced_code_blocks => true, :underline => true, :quote => true, :footnotes => true)
    @contents = markdown.render(contents)
  end

  def central
    if session[:player]
      @news = NewsPost.where(:public => true)
      @kills = Kill.order('created_at DESC').limit(20).where(:no_display => false)
      @kill = Kill.new
      @players = Player.where(:confirmed => true)
    else
      flash[:error] = "You must be registered and logged in to visit central."
      redirect_to '/welcome/index'
    end
  end

end
