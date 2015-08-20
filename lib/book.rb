class Book
  attr_reader(:id, :title)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id, nil)
    @title = attributes.fetch(:title)
  end

  define_singleton_method(:all) do
    books = []
    returned_books = DB.exec("SELECT * FROM books ORDER BY title;")
    returned_books.each do |book|
      id = book.fetch('id').to_i
      title = book.fetch('title')
      books.push(Book.new({id: id, title: title}))
    end
    books
  end

  define_singleton_method(:all_available) do
    available_books = []
    books = Book.all
    books.each do |book|
      available_books.push(book) if !book.checked_out?
    end
    available_books
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

    attributes.fetch(:patron_ids, []).each do |patron_id|
      DB.exec("INSERT INTO checkouts (patron_id, book_id, checkout_date) VALUES (#{patron_id}, #{id}, '#{Time.new.strftime('%Y/%m/%d')}');")
    end
  end

  define_method(:patrons) do
    patrons = []
    returned_checkouts = DB.exec("SELECT * FROM checkouts WHERE book_id = #{id} ORDER BY checkout_date;")
    returned_checkouts.each do |checkout|
      patron_id = checkout.fetch('patron_id').to_i
      name = Patron.find(patron_id).name
      patrons.push(Patron.new({name: name, id: patron_id}))
    end
    patrons
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

  define_method(:last_patron) do
    patrons.last()
  end

  define_method(:checked_out?) do
    returned_checkouts = DB.exec("SELECT * FROM checkouts WHERE book_id = #{id} AND return_date IS NULL;")
    returned_checkouts.each do |checkout|
      return true
    end
    false
  end

  define_method(:current_patron) do
    last_patron if checked_out?
  end

  define_method(:return) do
    if checked_out?
      patron_id = current_patron.id
      DB.exec("UPDATE checkouts SET return_date = '#{Time.new.strftime('%Y/%m/%d')}' WHERE patron_id = #{patron_id} AND book_id = #{id};")
    end
  end

end
