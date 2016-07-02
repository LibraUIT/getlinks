class BlogsController < ApplicationController
  before_action :current_categories, only: [:index]
  before_action :set_blog, only: [:show]

  def index
    @blogs = search_blogs(params)
  end

  def show
    @blog.update(views: @blog.views.to_i + 1)
    @blog.save
    @recommended = Blog.recommended(5).decorate
  end

  private

  def current_categories
    @categories = Category.by_actived
  end

  def search_blogs(params)
    order = params[:order].present? ? params[:order] : 'id DESC'
    per = params[:per].present? ? params[:per] : 6
    blogs = Blog.by_actived
    blogs = blogs.page(params[:page]).per(per).sort_by(order)
    blogs
  end

  def set_blog
    @blog = Blog.find(params[:id]).decorate
  end
end
