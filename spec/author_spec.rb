require('spec_helper')

describe(Author) do

  before do
    @author1 = Author.new({name: 'David Patorn'})
    @author2 = Author.new({name: 'Dr. Seuss'})
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
end
