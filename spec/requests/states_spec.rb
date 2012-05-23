require 'spec_helper'

describe "States page" do
  before do
    texas = State.create(code: "TX", name: "Texas")
    texas.members.create(
      first_name: "Joe", 
      last_name: "Shmoe", 
      nick_name: "Joe",
      photo_path: 'Images\Photos\SL\IN\S',
      photo_file: 'Landske_Dorothy_194409.jpg',
      chamber: 'S',
      website: 'S',
      facebook: 'S',
      email: 'S',
    )
    texas.members.create(
      first_name: "Joe2", 
      last_name: "Shmoe2", 
      nick_name: "Joe2",
      photo_path: 'Images\Photos\SL\IN\S',
      photo_file: 'Landske_Dorothy_194409.jpg',
      chamber: 'S',
      website: 'S',
      facebook: 'S',
      email: 'S',
    )
    indiana = State.create(code: "IN", name: "Indiana")
    indiana.members.create(
      first_name: "Peggy", 
      last_name: "Welch", 
      nick_name: "Peggy",
      photo_path: 'Images\Photos\SL\IN\S',
      photo_file: 'Landske_Dorothy_194409.jpg',
      chamber: 'H',
      website: 'S',
      facebook: 'S',
      email: 'S',
    )
    indiana.members.create(
      first_name: "Ben", 
      last_name: "Smith", 
      nick_name: "Benny",
      photo_path: 'Images\Photos\SL\IN\S',
      photo_file: 'Landske_Dorothy_194409.jpg',
      chamber: 'S',
      website: 'S',
      facebook: 'S',
      email: 'S',
    )
  end

  context "Date" do
    it "show the date for any date in url" do
      visit "/states/tx/2012/05/23"
      page.should have_content("Wednesday, May 23, 2012")
    end
  end

  context "Texas" do
    before do
      visit "/states/tx"
    end

    it "shows specific state" do
      page.should have_content("Texas")
    end

    it "shows name of member for state" do
      page.should have_content("Joe Shmoe")
    end

    it "shows name of member for state" do
      page.should have_content("Joe2 Shmoe2")
    end
  end

  context "Indiana" do
    before do
      visit "/states/in"
    end

    it "shows specific state" do
      page.should have_content("Indiana")
    end

    it "shows name of representative for state" do
      page.should have_content("House")
      page.should have_content("Peggy Welch")
    end

    it "shows name of senator for state" do
      page.should have_content("Senate")
      page.should have_content("Benny Smith")
    end

    it "includes image of member" do
      page.should have_selector('img.head-shot')
    end
  end
end
