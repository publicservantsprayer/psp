require 'spec_helper'

describe State do
  context "multiple_chambers?" do
    before do
      @texas = State.create(name: "Texas") 
      @texas.members.create(chamber: "H")
      @nebraska = State.create(name: "Nebraska") 
      @nebraska.members.create(chamber: "S")
      @indiana = State.create(name: "Indiana") 
      @indiana.members.create(chamber: "H")
      @indiana.members.create(chamber: "S")
      @dc = State.create(name: "Washington DC", code: "DC") 
      @dc.members.create(chamber: "H")
      @dc.members.create(chamber: "S")
    end 

    it "returns true if there is both house and senate" do
      @indiana.multiple_chambers?.should be_true
    end

    it "returns false if there is only a house" do
      @texas.multiple_chambers?.should be_false
    end

    it "returns false if there is only a senate" do
      @nebraska.multiple_chambers?.should be_false
    end

    it "returns false if state is DC" do
      @dc.multiple_chambers?.should be_false
    end
  end

end
