module Admin
  class BooksController < BaseController
    before_action :load_book, only: %i(edit update destroy)
    before_action :check_file_csv, only: :import
    def index
      @q = Book.ransack(params[:q])
      @books = @q.result(distinct: true)

      respond_to do |format|
        format.html
        format.csv { send_data @books.to_csv, filename: "books-#{Date.today}.csv" }
      end
    end

    def import
      Book.import_file params[:file]
      redirect_to admin_books_path, notice: I18n.t('common.data_imported')
    end

    def new
      @book = Book.new
    end
    
    def create
      @book = Book.new(book_params)
      if @book.save
        flash[:notice] = I18n.t('admin.managament.book.create_success')
        redirect_to admin_books_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @book.update(book_params)
        flash[:notice] = I18n.t('admin.managament.book.book_updated')
        redirect_to admin_books_path
      else
        render :edit
      end
    end

    def destroy
      @book.destroy
      flash[:notice] = I18n.t('admin.managament.book.book_deleted')
      redirect_to admin_books_path
    end

    private
    
    def book_params
      params.require(:book).permit(:name, :description, :price, :publisher, :image, :category_id, :creator_id)
    end 

    def load_book
      @book = Book.find_by(id: params[:id])
      return if @book
      render 'devise/shared/not_found'
    end

    def check_file_csv
      unless File.extname(params[:file].original_filename) == '.csv'
        redirect_to admin_books_path, notice: I18n.t('admin.managament.csv.errors.not_csv')
      end
    end
  end
end  
