class NewsController < ApplicationController

  def index
    @news = NewsPost.order('created_at DESC').limit(10).all

  end

  def new
    @news_post = NewsPost.new
  end

  def create
    @news_post = NewsPost.new(new_post_params)
    @news_post.author = session[:player].name
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
    if new_post_params[:public].nil?
      params[:public] = "false"
    end
    if @news_post.update_attributes(new_post_params) 
      flash[:success] = "Successfully saved news post."
      redirect_to '/administration/news'
    else
      flash[:error] = "Could not save news post."
      redirect_to :back
    end 
  end

  def destroy
    @news_post = NewsPost.find(params[:id])
    if @news_post.destroy 
      flash[:success] = "Successfully deleted news post."
      redirect_to '/administration/news'
    else
      flash[:error] = "Could not delete news post."
      redirect_to 'administration/news'
    end
  end

private
  
  def new_post_params
    params.permit(:title, :body, :public)
  end

end
