require 'sinatra'
require 'sinatra/reloader'
require './lib/author'
require './lib/book'
require './lib/patron'
require 'pg'
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "library"})

get '/' do
  @books = Book.all
  erb(:index)
end

get '/book/add' do
  erb(:add_book)
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
