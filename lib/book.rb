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

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{title}' WHERE id = #{id};")

    attributes.fetch(:author_ids, []).each do |author_id|
      DB.exec("INSERT INTO authors_books (author_id, book_id) VALUES (#{author_id}, #{id});")
    end
  end

  define_method(:authors) do
    authors = []
    returned_authors_books = DB.exec("SELECT * FROM authors_books WHERE book_id = #{self.id};")
    returned_authors_books.each do |author_book|
      author_id = author_book.fetch('author_id').to_i
      name = Author.find(author_id).name
      authors.push(Author.new({name: name, id: author_id}))
    end
    authors
  end

end
