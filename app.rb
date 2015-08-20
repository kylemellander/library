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
  book_id = params.fetch('id').to_i
  @book = Book.find(book_id)
  patron = @book.current_patron
  @book.return
  @success_message = "#{patron.name} has returned #{@book.title}."
  erb(:book_detail)
end
