class BooksController < ApplicationController

     before_action :correct_user, only: [:edit, :update]

  def show
    @books = Book.find(params[:id])
    @book = Book.new
    @user = @books.user
    @book_comment = BookComment.new
    
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)

    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
    if @isRoom
    else
      @room = Room.new
      @entry = Entry.new
    end
    end
  end

  def index

    @book = Book.new
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
   
  end


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all

      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private



   def correct_user
    book = Book.find(params[:id])
    user = book.user
    if current_user.id != user.id
      redirect_to books_path
    end
   end

  def book_params
    params.require(:book).permit(:title,:body)
  end



end
