class BooksController < ApplicationController
  before_action :load_book, only: :show
  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true)
  end

  def show
  end
  
  def load_book
    @book = Book.find_by(id: params[:id])
    return if @book
    render 'devise/shared/not_found'
  end
end
   