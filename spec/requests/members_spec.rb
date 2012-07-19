require 'spec_helper'

describe "State Members page" do
  before do
    indiana = FactoryGirl.create(:state, name: "Indiana", code: "IN")
    bob = FactoryGirl.create(:us_senator, state: indiana, nick_name: "Bob")
    sally = FactoryGirl.create(:senator, state: indiana, nick_name: "Sally")
    visit "/states/in/leaders"
  end

  it "shows members for a particular state" do
    page.should have_content("Indiana")
  end
  
  it "lists all members for a state" do
    page.should have_content("Bob")
    page.should have_content("Sally")
  end

  it "links each member to individual member page" do
    click_on "Bob"
    page.should have_content("Bob")
  end

  it "include prefix, nickname and last name in url" do
    pending "figure out how to test this"
    texas = FactoryGirl.create(:state, name: "Texas", code: "TX")
    bob = FactoryGirl.create(:us_senator, state: texas, prefix: "Sen.", nick_name: "Bob", last_name: "Smith")
    visit "/states/tx/leaders/#{bob.id}-sen-bob-smith"
  end
end
