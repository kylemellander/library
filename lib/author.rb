class Author
  attr_reader(:id, :name)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id, nil)
  end

  define_singleton_method(:all) do
    authors = []
    returned_authors = DB.exec("SELECT * FROM authors;")
    returned_authors.each do |author|
      id = author.fetch('id').to_i
      name = author.fetch('name')
      authors.push(Author.new({name: name, id: id}))
    end
    authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  define_method(:==) do |other|
    name() == other.name()
  end

  define_method(:delete) do
    DB.exec("DELETE FROM authors * WHERE id = #{id};")
  end

  define_singleton_method(:find) do |id|
    Author.all.each do |author|
      return author if author.id == id
    end
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE authors SET name = '#{name}' WHERE id = #{id};")
  end

end
