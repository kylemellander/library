require('rspec')
require('pry')
require('author')
require('book')
require('patron')
require('pg')

DB = PG.connect({:dbname => "library_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM authors_books *;")
    DB.exec("DELETE FROM checkouts *;")
  end
end
