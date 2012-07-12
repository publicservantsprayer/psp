require 'spec_helper'

describe "Member" do
  context "#name" do
    it "returns nickname lastname" do
      member = FactoryGirl.create(:member, first_name: "Dorothy", nick_name: "Sue", last_name: "Landske", prefix: "Sen.")
      member.name.should == "Sue Landske"
    end
  end

  context "#prefix_name" do
    it "returns nickname lastname" do
      member = FactoryGirl.create(:member, legislator_type: "SL",first_name: "Dorothy", nick_name: "Sue", last_name: "Landske", prefix: "Sen.")
      member.prefix_name.should == "Sen. Sue Landske"
    end

    it "includes 'US' in front of prefix for federal legislators" do
      member = FactoryGirl.create(:member, legislator_type: "FL", 
                                  first_name: "Dorothy", nick_name: "Sue", last_name: "Landske", prefix: "Sen.")
      member.prefix_name.should == "US Sen. Sue Landske"
    end
  end

  context "#photo_src" do
    it "returns path to photo" do
      member = Member.create(photo_path: 'Images\Photos\SL\IN\S', photo_file: 'Landske_Dorothy_194409.jpg')
      member.photo_src.should eq('/photos/SL/IN/S/Landske_Dorothy_194409.jpg')
    end
  end

  context "#information" do
    it "compiles information on existing data" do
      member = FactoryGirl.create(:member, birth_place: "Timbuktu")
      member.information.should include('Born in Timbuktu')
    end

    it "skips missing data" do
      member = FactoryGirl.create(:member, birth_place: "")
      member.information.should_not include('Born in')
    end
  end

  context "#military" do
    it "returns all three if all three" do
      member = Member.create(military_1_rank: "Sergeant", military_1_branch: "Army", military_1_dates: "1975-1980")
      member.military.should include("Sergeant in the Army from 1975-1980")
    end
    it "returns branch and dates if no rank" do
      member = Member.create(military_1_branch: "Army", military_1_dates: "1975-1980")
      member.military.should include("Army from 1975-1980")
    end
    it "returns rank and branch if no dates" do
      member = Member.create(military_1_rank: "Sergeant", military_1_branch: "Army")
      member.military.should include("Sergeant in the Army")
    end
    it "returns empty string if no branch" do
      member = Member.create(military_1_rank: "Sergeant", military_1_dates: "1975-1980")
      member.military.should == ""
    end
  end

end
