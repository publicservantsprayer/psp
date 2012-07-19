namespace :mail_chimp do

  task :set_up_segments => :environment do
    Subscription.set_up_segments
  end
end
