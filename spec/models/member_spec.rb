require 'spec_helper'

describe "Member" do
  context "#photo_src" do
    it "returns path to photo" do
      member = Member.create(photo_path: 'Images\Photos\SL\IN\S', photo_file: 'Landske_Dorothy_194409.jpg')
      member.photo_src.should eq('/photos/SL/IN/S/Landske_Dorothy_194409.jpg')
    end
  end

end
