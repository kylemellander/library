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
