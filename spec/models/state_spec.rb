require 'spec_helper'

describe State do

  context "#increment_single_chamber" do
    it "increments pointer_zero by 1" do
      state = FactoryGirl.create(:state_with_single_chamber)
      pointer_before = state.pointer_zero
      state.increment_single_chamber
      state.reload
      pointer_after = state.pointer_zero
      pointer_after.should == (pointer_before + 1)
    end

    it "increments pointer_one by 2" do
      state = FactoryGirl.create(:state_with_single_chamber)
      pointer_before = state.pointer_one
      state.increment_single_chamber
      state.reload
      pointer_after = state.pointer_one
      pointer_after.should == (pointer_before + 2)
    end

    it "increments pointer_two by 2" do
      state = FactoryGirl.create(:state_with_single_chamber)
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
      pointer_zero_before = state.pointer_zero
      pointer_one_before = state.pointer_one
      pointer_two_before = state.pointer_two
      state.verify_incremented
      state.reload
      pointer_zero_before.should_not == state.pointer_zero
      pointer_one_before.should_not == state.pointer_one
      pointer_two_before.should_not == state.pointer_two
    end

    it "does not increment if already incremented today" do
      state = FactoryGirl.create(:state, last_incremented_on: Date.yesterday)
      state.verify_incremented
      state.reload
      pointer_zero_before = state.pointer_zero
      pointer_one_before = state.pointer_one
      pointer_two_before = state.pointer_two
      state.verify_incremented
      state.reload
      pointer_zero_before.should == state.pointer_zero
      pointer_one_before.should == state.pointer_one
      pointer_two_before.should == state.pointer_two
    end
  end

  context "#increment_dual_chamber" do
    it "increments pointer_zero by 1" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      pointer_before = state.pointer_zero
      state.increment_single_chamber
      state.reload
      pointer_after = state.pointer_zero
      pointer_after.should == (pointer_before + 1)
    end

    it "increments pointer_one by 1" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      pointer_before = state.pointer_one
      state.increment_dual_chamber
      state.reload
      pointer_after = state.pointer_one
      pointer_after.should == (pointer_before + 1)
    end

    it "increments pointer_two by 1" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      pointer_before = state.pointer_two
      state.increment_dual_chamber
      state.reload
      pointer_after = state.pointer_two
      pointer_after.should == (pointer_before + 1)
    end

    it "pointer_zero loops back to beginning each cycle" do
      state = FactoryGirl.create(:state_with_dual_chamber, members_count: 70)
      state.update_attribute(:pointer_zero, 139)
      state.increment_dual_chamber
      state.reload
      state.pointer_zero.should == 0
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
    it "returns true if there is both house and senate" do
      FactoryGirl.create(:state_with_dual_chamber).dual_chamber?.should be_true
    end

    it "returns false if there is only a single chamber" do
      FactoryGirl.create(:state_with_single_chamber).dual_chamber?.should be_false
    end

    it "returns false if there is only a senate" do
      FactoryGirl.create(:state_with_single_chamber).dual_chamber?.should be_false
    end

    it "returns false if state is DC" do
      FactoryGirl.create(:state_with_dual_chamber, code: "DC").dual_chamber?.should be_false
    end
  end

  context "#member_zero, #member_one and #member_two" do
    it "returns false if date is earlier than today" do
      state = FactoryGirl.create(:state_with_single_chamber)
      state.member_one(Date.yesterday).should be_false
    end

    it "returns first member for a specific date in a state with single chamber" do
      state = FactoryGirl.create(:state_with_single_chamber)
      member_today_index = state.members.index( state.member_one(Date.today) )
      member_tomorrow_index = state.members.index( state.member_one(Date.tomorrow) )
      member_tomorrow_index.should == (member_today_index + 1)
    end

    it "loops around when pointer is on last member" do
      state = FactoryGirl.create(:state_with_single_chamber)
      member_count = state.members.state.count
      state.pointer_one = (member_count - 1)
      state.member_one(Date.tomorrow).should == state.members.state.first
    end

    it "loops around when looking into the future" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      state.member_one(Date.today + 5000).class.should == Member
    end

    it "returns different member each day" do
      state = FactoryGirl.create(:state_with_dual_chamber)
      todays_member = state.member_zero(Date.today)
      time_travel_to('tomorrow') do
        todays_member.should_not == state.member_zero(Date.today)
      end
    end

    describe "#member_zero" do
      it "returns US member" do
        state = FactoryGirl.create(:state_with_dual_chamber)
        state.members.first.legislator_type = "SL"
        state.member_zero(Date.today).legislator_type.should == "FL"
      end
    end

    describe "#member_one" do
      it "returns state member" do
        state = FactoryGirl.create(:state_with_dual_chamber)
        state.members.first.legislator_type = "FL"
        state.member_one(Date.today).legislator_type.should == "SL"
      end

      it "returns state member for state with single chamber" do
        state = FactoryGirl.create(:state_with_single_chamber)
        state.members.first.legislator_type = "FL"
        state.member_one(Date.today).legislator_type.should == "SL"
      end

      it "returns senator for a state with dual_chamber" do
        state = FactoryGirl.create(:state_with_dual_chamber)
        state.members.first.chamber = "H"
        state.member_one(Date.today).chamber.should == "S"
      end
    end

    describe "#member_two" do
      it "returns state member" do
        state = FactoryGirl.create(:state_with_dual_chamber)
        state.members[0].legislator_type = "FL"
        state.members[1].legislator_type = "FL"
        state.member_two(Date.today).legislator_type.should == "SL"
      end

      it "returns state member for a state with a single chamber" do
        state = FactoryGirl.create(:state_with_single_chamber)
        state.members[0].legislator_type = "FL"
        state.members[1].legislator_type = "FL"
        state.member_two(Date.today).legislator_type.should == "SL"
      end

      it "returns representative for a state with dual_chamber" do
        state = FactoryGirl.create(:state_with_dual_chamber)
        state.members.first.chamber = "S"
        state.member_two(Date.today).chamber.should == "H"
      end
    end

    it "member_one and member_two show different members for same day" do
      state = FactoryGirl.create(:state_with_single_chamber)
      state.member_one(Date.today).should_not == state.member_two(Date.today)
    end

    it "shows different members each day" do
      state = FactoryGirl.create(:state_with_single_chamber)
      state.last_incremented_on = Date.today
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

end
