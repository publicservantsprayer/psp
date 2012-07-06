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
      chamber "S"
      title "Senator"
    end

    factory :representative do
      chamber "H"
      title "Representative"
    end
  end

  factory :state do
    name "Texas"
    code "TX"

    factory :state_with_members do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:member, evaluator.members_count, state: state)
      end
    end

    factory :state_with_single_chamber do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:representative, evaluator.members_count, state: state)
      end
    end

    factory :state_with_dual_chamber do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:senator, evaluator.members_count, state: state)
        FactoryGirl.create_list(:representative, evaluator.members_count, state: state)
      end
    end

    factory :state_with_only_senators do
      ignore do
        members_count 5
      end

      after(:create) do |state, evaluator|
        FactoryGirl.create_list(:senator, evaluator.members_count, state: state)
      end
    end
  end

end
