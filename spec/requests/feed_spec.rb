require 'spec_helper'

describe "Daily calendar feed" do
  it "Shows current daily calendar" do
    pending
    FactoryGirl.create(:state_with_dual_chamber, code: "IN")
    visit "/states/in/feed.rss"
    page.should have_xpath("//rss/channel/item/title")
  end
end
