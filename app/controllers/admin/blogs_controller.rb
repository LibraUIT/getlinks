class Admin::BlogsController < Admin::ApplicationController
  before_action :current_category, only: [:edit_categorie, :update_categorie, :destroy_categorie]

  def index
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

  def current_category
    @categorie = Category.find(params[:id])
  end
end
