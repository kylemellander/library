require 'sinatra'
require 'sinatra/reloader'
require './lib/author'
require './lib/book'
require './lib/patron'
require 'pg'
require 'pry'
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "library"})

get '/' do
  @books = Book.all
  @page_title = ''
  erb(:index)
end

get '/book/available' do
  @page_title = 'Available '
  @books = Book.all_available()
  erb(:index)
end

get '/patron' do
  @patrons = Patron.all
  erb(:patron)
end

get '/author' do
  @authors = Author.all
  erb(:author)
end

get '/book/add' do
  erb(:add_book)
end

get '/patron/add' do
  erb(:add_patron)
end

get '/author/add' do
  erb(:add_author)
end

post '/book/submit' do
  title = params.fetch('title')
  author = params.fetch('author')
  book_id = Book.new({title: title}).save.to_i
  author_id = Author.new({name: author}).save.to_i
  book = Book.find(book_id)
  book.update({author_ids: [author_id]})
  @success_message = "You have added #{title} by #{author}."
  erb(:add_book)
end

post '/patron/submit' do
  name = params.fetch('name')
  Patron.new({name: name}).save
  @success_message = "You have added #{name} to our Patrons List."
  erb(:add_patron)
end

post '/author/submit' do
  name = params.fetch('name')
  Author.new({name: name}).save
  @success_message = "You have added #{name} to our Authors List."
  erb(:add_author)
end

get '/book/:id' do
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  erb(:book_detail)
end

get '/author/:id' do
  author_id = params.fetch('id').to_i
  @author = Author.find(author_id)
  erb(:author_detail)
end

get '/patron/:id' do
  patron_id = params.fetch('id').to_i
  @patron = Patron.find(patron_id)
  erb(:patron_detail)
end

get '/checkout/:id' do
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  erb(:checkout)
end

post '/checkout/success' do
  book_id = params.fetch('book_id').to_i
  @book = Book.find(book_id)
  new_user_name = params.fetch('new_patron')
  if new_user_name.sub(/\s+\Z/, "") == ""
    patron_id = params.fetch('current_patron').to_i
    @patron = Patron.find(patron_id)
  else
    @patron = Patron.new({name: new_user_name})
    @patron.save
  end
  @book.update({patron_ids: [@patron.id]})
  erb(:checkout_success)
end

get '/book/:id/return' do
  ref = params.fetch('ref')
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  @patron = @book.current_patron
  @book.return
  @success_message = "#{@patron.name} has returned #{@book.title}."
  if ref == "book"
    erb(:book_detail)
  elsif ref == "patron"
    erb(:patron_detail)
  else
    erb(:index)
  end
end

delete '/book/:id' do
  book_id = params.fetch('id').to_i
  book = Book.find(book_id)
  title = book.title
  book.delete
  @books = Book.all()
  @success_message = "#{title} has been removed from our collection"
  erb(:index)
end

delete '/author/:id' do
  author_id = params.fetch('id').to_i
  author = Author.find(author_id)
  name = author.name
  author.delete
  @authors = Author.all()
  @books = Book.all()
  @success_message = "Author #{name} has been removed from the system."
  erb(:index)
end

delete '/patron/:id' do
  patron_id = params.fetch('id').to_i
  patron = Patron.find(patron_id)
  name = patron.name
  patron.delete
  @patrons = Patron.all()
  @books = Book.all()
  @success_message = "#{name} has been removed from the system."
  erb(:index)
end

get '/book/:id/edit' do
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  erb(:edit_book)
end

patch '/book/:id' do
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  another_author_id = params.fetch('another_author').to_i
  new_author_name = params.fetch('new_author')
  title = params.fetch('title')
  if new_author_name.sub(/\s+\Z/, "") == "" && another_author_id != 0
    @book.update({author_ids: [another_author_id], title: title})
  elsif new_author_name.sub(/\s+\Z/, "") != "" && another_author_id != 0
    author = Author.new({name: new_author_name})
    author.save
    @book.update({author_ids: [another_author_id, author.id], title: title})
  elsif new_author_name.sub(/\s+\Z/, "") != "" && another_author_id == 0
    author = Author.new({name: new_author_name})
    author.save
    @book.update({author_ids: [author.id], title: title})
  else
    @book.update({title: title})
  end
  erb(:book_detail)
end
