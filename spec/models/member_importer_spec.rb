require 'spec_helper'

describe MemberImporter do
  let :know_who_data do
    { pid: "1234567", statecode: "TX" }
  end

  before do
    State.delete_all
    Member.delete_all
  end

  it "sets state on initilization" do
    FactoryGirl.create(:state, code: "TX")
    import = MemberImporter.new(know_who_data)
    import.state.code.should == "TX"
  end

  context "#member_exists?" do
    it "returns true if member exists" do
      texas = FactoryGirl.create(:state, code: "TX")
      FactoryGirl.create(:member, person_id: "123", state: texas)
      import = MemberImporter.new({ pid: "123", statecode: texas.code})
      import.member_exists?.should == true 
    end

    it "returns false if member does not exist" do
      texas = FactoryGirl.create(:state, code: "TX")
      FactoryGirl.create(:member, person_id: "123", state: texas)
      import = MemberImporter.new({ pid: "456", statecode: texas.code})
      import.member_exists?.should == false
    end
  end

  context "#create_or_update(know_who_data)" do
    before do
      State.delete_all
      Member.delete_all
    end

    it "returns member" do
      state = FactoryGirl.create(:state, code: "TX")
      member = MemberImporter.create_or_update(know_who_data)
      member.should be_an_instance_of(Member)
    end

    it "creates new member if not yet created" do
      state = FactoryGirl.create(:state, code: "TX")
      member1 = FactoryGirl.create(:member, state: state, person_id: "00001")
      member2 = MemberImporter.create_or_update(know_who_data)
      member2.id.should_not == member1.id
    end

    it "finds existing member if created" do
      state = FactoryGirl.create(:state, code: "TX")
      member1 = FactoryGirl.create(:member, person_id: "1234567", state: state)
      member2 = MemberImporter.create_or_update({ pid: "1234567", statecode: "TX"})
      member2.id.should == member1.id
    end

    it "attaches new member to state" do
      state = FactoryGirl.create(:state, code: "TX")
      member = MemberImporter.create_or_update(know_who_data)
      member.state.code.should == "TX"
    end

    it "updates attributes of existing member" do
      state = FactoryGirl.create(:state, code: "TX")
      member = FactoryGirl.create(:member, state: state, person_id: "1234567", marital_status: "single")
      MemberImporter.create_or_update({ pid: "1234567", statecode: "TX", marital: "married"})
      member.reload.marital_status.should == "married"
    end
    
    it "does not throw error if member has same state" do
      state = FactoryGirl.create(:state, code: "TX")
      member = FactoryGirl.create(:member, person_id: "1234567", state: state)
      lambda do
        MemberImporter.create_or_update({ pid: "1234567", statecode: "TX"})
      end.should_not raise_error
    end
    
    it "throws error if member has new state" do
      state = FactoryGirl.create(:state, code: "TX")
      FactoryGirl.create(:state, code: "CA")
      member = FactoryGirl.create(:member, state: state, person_id: "1234567")
      lambda do
        MemberImporter.create_or_update({ pid: "1234567", statecode: "CA"})
      end.should raise_error(RuntimeError, "Know Who data tried to change member state")
    end

    it "throws error if state not found" do
      state = FactoryGirl.create(:state, code: "TX")
      member = FactoryGirl.create(:member, state: state, person_id: "1234567")
      lambda do
        MemberImporter.create_or_update({ pid: "1234567", statecode: "CA"})
      end.should raise_error(RuntimeError, "Know Who data state not found")
    end
  end
end
