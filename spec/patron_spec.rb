require('spec_helper')

describe(Patron) do

  before do
    @patron1 = Patron.new({name: 'Dave'})
    @patron2 = Patron.new({name: 'Ryan'})
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
  end

  describe(".all") do
    it("returns empty array when empty") do
      expect(Patron.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("saves the Patron into the patrons table") do
      @patron1.save
      expect(Patron.all()).to(eq([@patron1]))
    end
  end

  describe("#delete") do
    it("deletes a Patron from the database") do
      @patron1.save
      @patron2.save
      @patron1.delete
      expect(Patron.all()).to(eq([@patron2]))
    end
  end

  describe(".find") do
    it("retrieves a Patron from the database") do
      @patron1.save
      @patron2.save
      expect(Patron.find(@patron1.id)).to(eq(@patron1))
    end
  end

  describe("#update") do
    it "updates the name of a patron" do
      @patron1.save
      @patron1.update({name: "Kyle"})
      expect(@patron1.name()).to eq "Kyle"
    end

    it "creates join association for patrons and books" do
      @patron1.save
      @book1.save
      @book2.save
      @patron1.update({book_ids: [@book1.id, @book2.id]})
      expect(@patron1.books()).to eq [@book1, @book2]
    end
  end

  describe("#status") do
    it "returns array of books currently checked out by patron" do
      @patron1.save
      @book1.save
      @book2.save
      @patron1.update({book_ids: [@book1.id]})
      expect(@patron1.status()).to eq [@book1]
    end
  end
end
