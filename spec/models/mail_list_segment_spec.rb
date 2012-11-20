require 'spec_helper'

describe MailListSegment do
  it "knows its name" do
    segment = MailListSegment.new(UsState.new('tx'), 'daily')
    segment.name.should == 'Daily-TX-Texas'
  end

  it "knows its public name" do
    segment = MailListSegment.new(UsState.new('tx'), 'daily')
    segment.public_name.should == 'Texas Daily Prayer List'
  end

  it "creates itself on MailChimp" do
    VCR.use_cassette "mail_chimp_segment/creates_itself" do
      segment = MailListSegment.new(UsState.new('tx'), 'daily-test')
      segment.create
      segments = MailChimp.new.segments.collect{|s|s['name']}
      segments.include?('tx-daily-test').should be_true
    end
  end

  # Most of the code expects segments to be named like "tx-daily"
  # but PSP segments are named "Daily-TX-Texas" and cant be changed
  it 'can find segment id based on cycle and state but not full name' do
    segments = [
      {'name' => 'Cycle-ST-Test_State',     'id' => '123'},
      {'name' => 'Daily-TX-TexasWeirdName', 'id' => '456'},
      {'name' => 'Other-OT-Other_State',    'id' => '789'}
    ]
    mls = MailListSegment.new(UsState.new('tx'), 'daily')
    mls.mail_chimp_id(segments).should == '456'
  end
end
