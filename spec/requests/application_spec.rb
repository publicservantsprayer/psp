require 'spec_helper'

describe "Application" do

  context "Detects IP and looks up state" do
    it "Shows correct state for Indiana IP" do
      pending
      #page.driver.request.headers['REMOTE_ADDR'] = '50.102.5.56'
      #visit '/'
      #page.should have_content('Indiana')
    end

    it "Shows correct state for Illinois" do
      pending
      #page.driver.request.headers['REMOTE_ADDR'] = '208.82.101.23'
      #visit '/'
      #page.should have_content('Illinois')
    end
  end
end
