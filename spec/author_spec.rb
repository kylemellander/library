require('spec_helper')

describe(Author) do

  before do
    @author1 = Author.new({name: 'David Patorn'})
    @author2 = Author.new({name: 'Dr. Seuss'})
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
  end

  describe(".all") do
    it("returns empty array when empty") do
      expect(Author.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("saves the Author into the authors table") do
      @author1.save
      expect(Author.all()).to(eq([@author1]))
    end
  end

  describe("#delete") do
    it("deletes a Author from the database") do
      @author1.save
      @author2.save
      @author1.delete
      expect(Author.all()).to(eq([@author2]))
    end
  end

  describe(".find") do
    it("retrieves a Author from the database") do
      @author1.save
      @author2.save
      expect(Author.find(@author1.id)).to(eq(@author1))
    end
  end

  describe("#books") do
    it("returns array of books associated with author") do
      @book1.save
      @book2.save
      @author1.save
      @author1.update({book_ids: [@book1.id]})
      expect(@author1.books).to eq [@book1]
    end
  end

  describe("#update") do
    it('updates the name of the author in the database') do
      @author1.save
      @author1.update({name: 'David Patron'})
      expect(@author1.name).to eq 'David Patron'
    end

    it('creates a join association for authors and books') do
      @book1.save
      @book2.save
      @author1.save
      @author1.update({book_ids: [@book1.id, @book2.id]})
      expect(@author1.books).to eq [@book1, @book2]
    end
  end

end
