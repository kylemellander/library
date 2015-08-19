require('spec_helper')

describe(Patron) do

  before do
    @patron1 = Patron.new({name: 'Dave'})
    @patron2 = Patron.new({name: 'Ryan'})
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
end
