require 'spec_helper'

describe "Calendar pages" do
  it "shows daily calendar" do
    texas = FactoryGirl.create(:state, code: "TX", name: "Texas")
    visit "/states/tx/calendars/daily"
    page.should have_content("Texas Daily Prayer Calendar")
  end

  it "defaults to today" do
    pending
    texas = FactoryGirl.create(:state, code: "TX", name: "Texas")
    visit "/states/tx/calendars/daily"
    page.should have_content(Date.today.strftime("%A, %B %-d, %Y"))
  end

  it "shows weekly calendar"

  it "allows subscription to state daily email list" do
    texas = FactoryGirl.create(:state, code: "TX", name: "Texas")
    visit "/states/tx/calendars/daily"
    fill_in 'Email', with: 'joe@smith.com' 
    click_on 'Subscribe'
    page.should have_content('Success')
  end

  it "subscribe gives error without email" do
    texas = FactoryGirl.create(:state, code: "TX", name: "Texas")
    visit "/states/tx/calendars/daily"
    click_on 'Subscribe'
    page.should have_content('Error')
  end

end
