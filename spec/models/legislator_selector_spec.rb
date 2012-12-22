require 'spec_helper'

describe LegislatorSelector do
  let :state do
    state = UsState.new('tx')
  end

  let :b_day do
    Date.new(2012, 7, 4)
  end

  context "#us_congress" do
    it "returns an array of members of the US Congress" do
      legislators = LegislatorSelector.new(state, b_day).us_congress
      legislators.first.title.include?("US ").should be_true
    end

    it "returns different set of US Congress each day" do
      leaders = LegislatorSelector.new(state, b_day.prev_day).us_congress
      leaders.should_not == LegislatorSelector.new(state, b_day).us_congress
    end

    it "returns 2 different senators for sequential days" do
      state = UsState.new('ne')
      leaders = LegislatorSelector.new(state, b_day).us_congress
      next_days_leaders = LegislatorSelector.new(state, b_day.next_day).us_congress
      leaders.include?(next_days_leaders.first).should be_false
      leaders.include?(next_days_leaders.last).should be_false
    end
  end

  context "#state_senate" do
    it "returns an array of state senate" do
      legislators = LegislatorSelector.new(state, b_day).state_senate
      legislators.first.title.should == "Texas Senator"
    end

    it "returns 2 state senators for nebraska" do
      state = UsState.new('ne')
      legislators = LegislatorSelector.new(state, b_day).state_senate
      legislators.length.should == 2
    end

    it "returns 1 state senator for non nebraska states" do
      state_codes = %w[ in tx nc ]
      state_codes.each do |state_code|
        legislators = LegislatorSelector.new(UsState.new(state_code), b_day).state_senate
        legislators.length.should == 1
      end
    end
  end

  context "#state_house" do
    it "returns an array of state house members" do
      legislators = LegislatorSelector.new(state, b_day).state_house
      legislators.first.title.should == "Texas Representative"
    end
  end

  context "#self.for_day" do
    it "returns an array of legislators for specific day" do
      LegislatorSelector.for_day(state, b_day).length.should == 3
    end
  end
end
