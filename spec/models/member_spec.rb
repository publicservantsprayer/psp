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

  context "#born" do
    it "return location, month, day if it has all" do
      member = Member.create(birth_place: "texas", birth_month: "09", birth_day: "15")
      member.born.should include("Born in texas on September, 15th")
    end
    it "return only location if there is location, but no month" do
      member = Member.create(birth_place: "texas", birth_day: "15")
      member.born.should include("Born in texas")
    end
    it "return location, month if there is location, month but no day" do
      member = Member.create(birth_place: "texas", birth_month: "09")
      member.born.should include("Born in texas in the month of September")
    end
    it "returns month, day if there is month, day but no location" do
      member = Member.create(birth_month: "09", birth_day: "15")
      member.born.should include("Born on September, 15th")
    end
    it "returns month only if there is month but no day or location" do
      member = Member.create(birth_month: "09")
      member.born.should include("Born in September")
    end
    it "returns empty string if there is no month or location" do
      member = Member.create(birth_day: "15")
      member.born.should == ""
    end
    it "returns ordinalized day" do
      member = Member.create(birth_month: "09", birth_day: "1")
      member.born.should include("Born on September, 1st")
      member = Member.create(birth_month: "09", birth_day: "2")
      member.born.should include("Born on September, 2nd")
      member = Member.create(birth_month: "09", birth_day: "3")
      member.born.should include("Born on September, 3rd")
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
