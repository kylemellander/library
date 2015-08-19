require('spec_helper')

describe(Book) do

  before do
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
    @author1 = Author.new({name: "Joseph Conrad"})
    @author2 = Author.new({name: "David Patorn"})
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
  end

end
