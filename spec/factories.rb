FactoryGirl.define do
  sequence :member_name do |n|
    "Joe Congressman#{n}"
  end

  factory :member do
    state
    first_name "Joe" 
    last_name "Shmoe"
    nick_name { generate(:member_name) }
    photo_path 'Images\Photos\SL\IN\S'
    photo_file 'Landske_Dorothy_194409.jpg'
    
    factory :senator do
      legislator_type "SL"
      chamber "S"
      title "Senator"
    end

    factory :representative do
      legislator_type "SL"
      chamber "H"
      title "Representative"
    end
    
    factory :us_senator do
      legislator_type "FL"
      chamber "S"
      title "US Senator"
    end

    factory :us_representative do
      legislator_type "FL"
      chamber "H"
      title "US Representative"
    end
  end

  factory :state do
    name "Texas"
    code "TX"

    factory :state_with_single_chamber do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:senator, evaluator.members_count, state: state, legislator_type: "SL")
        FactoryGirl.create_list(:us_senator, evaluator.members_count, state: state)
        FactoryGirl.create_list(:us_representative, evaluator.members_count, state: state)
      end
    end

    factory :state_with_dual_chamber do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:senator, evaluator.members_count, state: state, legislator_type: "SL")
        FactoryGirl.create_list(:representative, evaluator.members_count, state: state, legislator_type: "SL")
        FactoryGirl.create_list(:us_senator, evaluator.members_count, state: state)
        FactoryGirl.create_list(:us_representative, evaluator.members_count, state: state)
      end
    end

  end

end
