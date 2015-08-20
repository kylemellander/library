require('spec_helper')

describe(Book) do

  before do
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
    @author1 = Author.new({name: "Joseph Conrad"})
    @author2 = Author.new({name: "David Patorn"})
    @patron1 = Patron.new({name: 'Dave'})
    @patron2 = Patron.new({name: 'Ryan'})
  end

  describe('.all') do
    it 'returns an empty array' do
      expect(Book.all).to eq []
    end
  end

  describe('#save') do
    it 'saves a Book to the database' do
      @book1.save
      expect(Book.all).to eq [@book1]
    end
  end

  describe('#delete') do
    it 'removes a Book from the database' do
      @book1.save
      @book2.save
      @book1.delete
      expect(Book.all).to eq [@book2]
    end
  end

  describe('.find') do
    it 'finds a specific book by id' do
      @book1.save
      @book2.save
      expect(Book.find(@book1.id)).to eq @book1
    end
  end

  describe('#authors') do
    it "lists all authors of a book" do
      @book1.save
      @book2.save
      @author1.save
      @book1.update({author_ids: [@author1.id]})
      expect(@book1.authors).to eq [@author1]
    end
  end

  describe('#patrons') do
    it "lists all patrons of a book" do
      @book1.save
      @book2.save
      @patron1.save
      @book1.update({patron_ids: [@patron1.id]})
      expect(@book1.patrons).to eq [@patron1]
    end
  end

  describe('#current_patron') do
    it "returns the patron who currently has the book" do
      @book1.save
      @book2.save
      @patron1.save
      @patron2.save
      @patron2.update({book_ids: [@book1.id]})
      expect(@book1.current_patron).to eq @patron2
    end
  end

  describe("#update") do
    it "updates the title of a book" do
      @book1.save
      @book1.update({title: "The Heart of Darkness"})
      expect(@book1.title()).to eq "The Heart of Darkness"
    end

    it "creates join association for authors and books" do
      @book1.save
      @author1.save
      @author2.save
      @book1.update({author_ids: [@author1.id, @author2.id]})
      expect(@book1.authors()).to eq [@author1, @author2]
    end

    it "creates join association for books and patrons" do
      @book1.save
      @patron1.save
      @patron2.save
      @book1.update({patron_ids: [@patron1.id, @patron2.id]})
      expect(@book1.patrons()).to eq [@patron1, @patron2]
    end
  end

  describe("#last_patron") do
    it 'returns the last patron to checkout the book' do
      @book1.save
      @patron1.save
      @patron2.save
      @book1.update({patron_ids: [@patron1.id]})
      @book1.update({patron_ids: [@patron2.id]})
      expect(@book1.last_patron).to eq @patron2
    end
  end

  describe("#checked_out?") do
    it "returns true if book is checked out" do
    @book1.save
    @patron1.save
    @book1.update({patron_ids: [@patron1.id]})
    expect(@book1.checked_out?).to eq true
    end

    it "returns false if book is NOT checked out" do
      @book1.save
      expect(@book1.checked_out?).to eq false
    end
  end

  describe("#return") do
    it "returns a book and sets date for returned_date in DB" do
      @book1.save
      @patron1.save
      @book1.update({patron_ids: [@patron1.id]})
      @book1.return
      expect(@book1.checked_out?).to eq false
    end
  end

  describe('.all_available') do
    it "returns an array of all available books" do
      @book1.save
      @book2.save
      @patron1.save
      @book1.update({patron_ids: [@patron1.id]})
      expect(Book.all_available).to eq [@book2]
    end
  end

  describe('#due_date') do
    it "returns the date a book is due" do
      @book1.save
      @patron1.save
      @book1.update({patron_ids: [@patron1.id]})
      expect(@book1.due_date).to eq "09/03/2015"
    end
  end

end
