require 'spec_helper'

describe "UsState" do
  it "knows its name" do
    state = UsState.new('tx')
    state.name.should == "Texas" 
  end

  it "knows its own leaders" do
      state = UsState.new('tx')
      state.leaders.should_not be_empty 
  end

  it "shows mashed name" do
    state = UsState.new('nc')
    state.mashed_name.should == "northcarolina"
  end
end
