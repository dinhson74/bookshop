class CommentsController < ApplicationController
  before_action :load_book, only: %i(create destroy)
  before_action :load_comment, only: :destroy
  def create
    @comment = @book.comments.new((comment_params).merge(user: current_user))
    if @comment.save
      redirect_to @book
    else
      flash[:alert] = @comment.errors.full_messages.join
      redirect_to @book
    end
  end

  def destroy
    if @comment.destroy
      redirect_to @book
    end
  end
 
  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_book
    @book = Book.find_by(id: params[:book_id])
    return if @book
    render 'devise/shared/not_found'
  end

  def load_comment
    @comment = @book.comments.find_by(id: params[:id])
    return if @comment
    render 'devise/shared/not_found'
  end
end
