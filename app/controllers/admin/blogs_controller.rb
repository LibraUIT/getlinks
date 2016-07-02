class Admin::BlogsController < Admin::ApplicationController
  before_action :current_category, only: [:edit_categorie, :update_categorie, :destroy_categorie]
  before_action :all_categories, only: [:new, :create, :edit, :update]
  before_action :current_blog, only: [:edit, :update, :destroy]

  def index
    @blogs = search_blogs(params)
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.create(blog_params.merge({author: current_user.id}))
    respond_to do |format|
      if @blog.save
        format.html { redirect_to admin_blogs_path, notice: 'Blog was successfully created.' }
        format.json { render :new, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    @blog.update(blog_params)
    respond_to do |format|
      if @blog.save
        format.html { redirect_to edit_admin_blog_path(@blog), notice: 'Blog was successfully updated.' }
        format.json { render :edit, status: :created, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    id = @blog.id
    @blog.destroy
    respond_to do |format|
      format.html
      format.js { render "destroy", :locals => {:id => id}}
    end
  end

  def new_categorie
    @categorie = Category.new
  end

  def create_categorie
    @categorie = Category.create(categorie_params)
    respond_to do |format|
      if @categorie.save
        format.html { redirect_to categories_admin_blogs_path, notice: 'Category was successfully created.' }
        format.json { render :new_categorie, status: :created, location: @categorie }
      else
        format.html { render :new_categorie }
        format.json { render json: @categorie.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_categorie; end

  def update_categorie
    @categorie.update(categorie_params)
    respond_to do |format|
      if @categorie.save
        format.html { redirect_to edit_categorie_admin_blogs_path(@categorie), notice: 'Category was successfully updated.' }
        format.json { render :edit_categorie, status: :created, location: @categorie }
      else
        format.html { render :edit_categorie }
        format.json { render json: @categorie.errors, status: :unprocessable_entity }
      end
    end
  end

  def categories
    @categories = Category.all
  end

  def destroy_categorie
    id = @categorie.id
    @categorie.destroy
    respond_to do |format|
      format.html
      format.js { render "destroy_categorie", :locals => {:id => id}}
    end
  end

  private

  def categorie_params
    params.require(:category).permit(:name, :status)
  end

  def blog_params
    params.require(:blog).permit(:category_id, :title, :content, :image, :status, :keywords)
  end

  def current_category
    @categorie = Category.find(params[:id])
  end

  def current_blog
    @blog = Blog.find(params[:id])
  end

  def all_categories
    @categories = Category.by_actived
  end

  def search_blogs(params)
    blogs = Blog.all
  end
end
