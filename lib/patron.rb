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
    DB.exec("DELETE FROM patrons * WHERE id = #{id}")
  end
end
