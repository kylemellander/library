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

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  define_method(:==) do |other|
    title == other.title
  end

  define_method(:delete) do
    DB.exec("DELETE FROM books * WHERE id = #{id}")
  end

  define_singleton_method(:find) do |id|
    Book.all.each do |book|
      return book if book.id == id
    end
  end
  
end
