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

  describe('#==')
end
