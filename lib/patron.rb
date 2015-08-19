class Patron
  attr_reader(:id, :name)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id, nil)
  end

  define_singleton_method(:all) do
    patrons = []
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    returned_patrons.each do |patron|
      id = patron.fetch('id').to_i
      name = patron.fetch('name')
      patrons.push(Patron.new({name: name, id: id}))
    end
    patrons
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  define_method(:==) do |other|
    name() == other.name()
  end

  define_method(:delete) do
    DB.exec("DELETE FROM patrons * WHERE id = #{id};")
  end

  define_singleton_method(:find) do |id|
    Patron.all.each do |patron|
      return patron if patron.id == id
    end
  end

  define_method(:books) do
    books = []
    returned_checkouts = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{id};")
    returned_checkouts.each do |checkout|
      book_id = checkout.fetch('book_id').to_i
      title = Book.find(book_id).title
      books.push(Book.new({id: book_id, title: title}))
    end
    books
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id = #{id};")

    attributes.fetch(:book_ids, []).each do |book_id|
      DB.exec("INSERT INTO checkouts (book_id, patron_id, borrowed_date) VALUES (#{book_id}, #{id}, '#{Time.now.strftime('%Y/%m/%d')}');")
    end
  end

end
