require 'spec_helper'

describe Subscription do
  context "#update_segment" do
    it "sets up a daily segment" do
      FactoryGirl.create(:state, code: "TX", name: "Texas", daily_segment_id: nil)
      segment = {"id" => "123", "name" => "Daily-TX-Texas"}
      Subscription.update_segment(segment)

      State.find('tx').daily_segment_id.should == 123
    end

    it "sets up a weekly segment" do
      FactoryGirl.create(:state, code: "TX", name: "Texas", weekly_segment_id: nil)
      segment = {"id" => "123", "name" => "Weekly-TX-Texas"}
      Subscription.update_segment(segment)

      State.find('tx').weekly_segment_id.should == 123
    end
  end
end
