require 'spec_helper'

describe "Calendar" do
  it "shows multiple days of praying" do
    visit "/states/in/calendar"
    page.should have_content("Calendar") 
  end
end

