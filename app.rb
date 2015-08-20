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
