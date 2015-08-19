class Book
  attr_reader(:id, :title)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id, nil)
    @title = attributes.fetch(:title)
  end

  define_singleton_method(:all) do
    books = []
    returned_books = DB.exec("SELECT * FROM books;")
    returned_books.each do |book|
      id = book.fetch('id').to_i
      title = book.fetch('title')
      books.push(Book.new({id: id, title: title}))
    end
    books
  end
end
