module Admin
  class CategoriesController < BaseController
    before_action :load_category, only: %i(edit update destroy)
    before_action :check_file_csv, only: :import
    def index
      @q = Category.ransack(params[:q])
      @categories = @q.result(distinct: true)

      respond_to do |format|
        format.html
        format.csv { send_data @categories.to_csv, filename: "categories-#{Date.today}.csv" }
      end
    end

    def import
      Category.import_file params[:file]
      redirect_to admin_categories_path, notice: I18n.t('common.data_imported')
    end

    def new
      @category = Category.new
    end
    
    def create
      @category = Category.new(category_params)
      if @category.save
        flash[:notice] = I18n.t('admin.managament.category.create_success')
        redirect_to admin_categories_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        flash[:notice] = I18n.t('admin.managament.category.category_updated')
        redirect_to admin_categories_path
      else
        render :edit
      end
    end

    def destroy
      @category.destroy
      flash[:notice] = I18n.t('admin.managament.category.category_deleted')
      redirect_to admin_categories_path
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end 

    def load_category
      @category = Category.find_by(id: params[:id])
      return if @category
      render 'devise/shared/not_found'
    end

    def check_file_csv
      unless File.extname(params[:file].original_filename) == '.csv'
        redirect_to admin_categories_path, notice: I18n.t('admin.managament.csv.errors.not_csv')
        return
      end
    end
  end
end
  