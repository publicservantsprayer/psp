require 'spec_helper'

describe State do

  context "#increment_single_chamber" do
    it "increments pointer_one by 2" do
      state = FactoryGirl.create(:state)
      pointer_before = state.pointer_one
      state.increment_single_chamber
      state.reload
      pointer_after = state.pointer_one
      pointer_after.should == (pointer_before + 2)
    end

    it "increments pointer_two by 2" do
      state = FactoryGirl.create(:state)
      pointer_before = state.pointer_two
      state.increment_single_chamber
      state.reload
      pointer_after = state.pointer_two
      pointer_after.should == (pointer_before + 2)
    end

    it "pointer_one loops back to beginning each cycle" do
      state = FactoryGirl.create(:state_with_single_chamber, members_count: 140)
      state.update_attribute(:pointer_one, 138)
      state.increment_single_chamber
      state.reload
      state.pointer_one.should == 0
    end

    it "pointer_two loops back to beginning each cycle" do
      state = FactoryGirl.create(:state_with_single_chamber, members_count: 140)
      state.update_attribute(:pointer_two, 139)
      state.increment_single_chamber
      state.reload
      state.pointer_two.should == 1
    end
  end

  context "#verify_incremented" do
    it "increments if not yet incremented today" do
      state = FactoryGirl.create(:state, last_incremented_on: Date.yesterday)
      pointer_one_before = state.pointer_one
      pointer_two_before = state.pointer_two
      state.verify_incremented
      state.reload
      pointer_one_before.should_not == state.pointer_one
      pointer_two_before.should_not == state.pointer_two
    end

    it "does not increment if already incremented today" do
      state = FactoryGirl.create(:state, last_incremented_on: Date.yesterday)
      state.verify_incremented
      state.reload
      pointer_one_before = state.pointer_one
      pointer_two_before = state.pointer_two
      state.verify_incremented
      state.reload
      pointer_one_before.should == state.pointer_one
      pointer_two_before.should == state.pointer_two
    end
  end

  context "#increment_dual_chamber" do
    it "increments pointer_one by 1" do
      state = FactoryGirl.create(:state)
      pointer_before = state.pointer_one
      state.increment_dual_chamber
      state.reload
      pointer_after = state.pointer_one
      pointer_after.should == (pointer_before + 1)
    end

    it "increments pointer_two by 1" do
      state = FactoryGirl.create(:state)
      pointer_before = state.pointer_two
      state.increment_dual_chamber
      state.reload
      pointer_after = state.pointer_two
      pointer_after.should == (pointer_before + 1)
    end

    it "pointer_one loops back to beginning each cycle" do
      state = FactoryGirl.create(:state_with_dual_chamber, members_count: 140)
      state.update_attribute(:pointer_one, 139)
      state.increment_dual_chamber
      state.reload
      state.pointer_one.should == 0
    end

    it "pointer_two loops back to beginning each cycle" do
      state = FactoryGirl.create(:state_with_dual_chamber, members_count: 140)
      state.update_attribute(:pointer_two, 139)
      state.increment_dual_chamber
      state.reload
      state.pointer_two.should == 0
    end

  end

  context "dual_chamber?" do
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
      @indiana.dual_chamber?.should be_true
    end

    it "returns false if there is only a house" do
      @texas.dual_chamber?.should be_false
    end

    it "returns false if there is only a senate" do
      @nebraska.dual_chamber?.should be_false
    end

    it "returns false if state is DC" do
      @dc.dual_chamber?.should be_false
    end
  end

  context "#member_one and #member_two" do
    it "returns false if date is earlier than today" do
      state = FactoryGirl.create(:state_with_members)
      state.member_one(Date.yesterday).should be_false
    end

    it "returns first member for a specific date in a state with single chamber" do
      state = FactoryGirl.create(:state_with_only_senators)
      member_today_index = state.members.index( state.member_one(Date.today) )
      member_tomorrow_index = state.members.index( state.member_one(Date.tomorrow) )
      member_tomorrow_index.should == (member_today_index + 1)
    end

    it "loops around when pointer is on last member" do
      state = FactoryGirl.create(:state_with_members)
      member_count = state.members.count
      state.pointer_one= (member_count - 1)
      state.member_one(Date.tomorrow).should == state.members.first
    end

    it "loops around when looking into the future" do
      state = FactoryGirl.create(:state_with_members)
      state.member_one(Date.today + 5000).class.should == Member
    end

    it "member_one returns representative for a state with dual_chamber" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      state.members.first.chamber = "S"
      state.member_one(Date.today).chamber.should == "H"
    end

    it "member_two returns senator for a state with dual_chamber" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      state.members.first.chamber = "H"
      state.member_two(Date.today).chamber.should == "S"
    end

    it "member_one and member_two show different members for same day" do
      state = FactoryGirl.create(:state_with_only_senators)
      state.member_one(Date.today).should_not == state.member_two(Date.today)
    end

    it "shows different members each day" do
      state = FactoryGirl.create(:state_with_members)
      todays_member_one = state.member_one(Date.today)
      todays_member_two = state.member_two(Date.today)
      time_travel_to("tomorrow") do
        tomorrows_member_one = state.member_one(Date.today)
        tomorrows_member_two = state.member_two(Date.today)
        todays_member_one.should_not == tomorrows_member_one
        todays_member_two.should_not == tomorrows_member_two
      end
    end
  end


  context "#member_news" do
    it "returns member mentioned most in the current news"
  end

end
