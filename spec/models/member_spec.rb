require 'spec_helper'

describe "Member" do
  context "#photo_src" do
    it "returns path to photo" do
      member = Member.create(photo_path: 'Images\Photos\SL\IN\S', photo_file: 'Landske_Dorothy_194409.jpg')
      member.photo_src.should eq('/photos/SL/IN/S/Landske_Dorothy_194409.jpg')
    end
  end

  context "#information" do
    it "compiles information on existing data" do
      member = Member.create(birth_place: "Timbuktu", name: "bob")
      member.information.should include('Born in Timbuktu')
    end
    it "skips missing data" do
      member = Member.create(name: "bob")
      member.information.should_not include('Born in')
    end
  end

end
