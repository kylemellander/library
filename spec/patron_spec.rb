require('spec_helper')

describe(Patron) do

  before do
    @patron1 = Patron.new({name: 'Dave'})
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
end
