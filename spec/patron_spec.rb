require('spec_helper')

describe(Patron) do
  describe(".all") do
    it("returns empty array when empty") do
      expect(Patron.all()).to(eq([]))
    end
  end
end
