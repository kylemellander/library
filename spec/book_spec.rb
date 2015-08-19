require('spec_helper')

describe(Book) do

  before do
    @book1 = Book.new({title: "Heart of Darkness"})
    @book2 = Book.new({title: "The Name of the Wind"})
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

end
