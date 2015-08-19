class Patron

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id, nil)
  end

  define_singleton_method(:all) do
    patrons = []
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    returned_patrons.each do |patron|
      id = patron.fetch('id').to_i
      name = patorn.fetch('name')
      patrons.push(Patron.new({name: name, id: id}))
    end
    patrons
  end
end
