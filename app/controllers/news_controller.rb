class NewsController < ApplicationController

  def index
    @news = NewsPost.all
  end

  def new
    @news_post = NewsPost.new
  end

  def create
    @news_post = NewsPost.new(:title => new_post_params[:title],
                                 :body => new_post_params[:body])
    @news_post.author = session[:player].name
    if new_post_params[:public] == "true"
      @news_post.hidden = false
    else
      @news_post.hidden = true
    end
    if @news_post.save
      flash[:success] = "Successfully saved news post."
      redirect_to '/administration/news'
    else
      flash[:error] = "Could not save news post."
      redirect_to :back
    end
  end

  def edit
    @news_post = NewsPost.find(params[:id])
  end

  def update
    @news_post = NewsPost.find(params[:id])
    if new_post_params[:public] == "true"
      @news_post.hidden = false
    else
      @news_post.hidden = true
    end
    if @news_post.update_attributes(:title => new_post_params[:title],
                                 :body => new_post_params[:body]) 
      flash[:success] = "Successfully saved news post."
      redirect_to '/administration/news'
    else
      flash[:error] = "Could not save news post."
      redirect_to :back
    end 
  end

  def destroy
  
  end

private
  
  def new_post_params
    params.permit(:title, :body, :public)
  end

end
