require 'csv'

namespace :know_who do
  task :download_latest_data do
    `mkdir -p know_who/raw`
    `cd know_who/raw && wget ftp://ftp_capitolcomm:ktr84sbe@205.134.170.180/* `
    `cd know_who/raw && unzip *.zip`
  end

  task :import => :environment do
    Rake::Task["know_who:setup_files"].execute
    Rake::Task["know_who:import_state_records"].execute
    Rake::Task["know_who:import_member_records"].execute
    #Rake::Task["know_who:import_bio_records"].execute
  end

  task :delete_state_records => :environment do
    puts "removing old state data"
    count = State.delete_all
    puts "removed #{count} state records"
  end

  task :delete_member_records => :environment do
    puts "removing old member data"
    count = Member.delete_all
    puts "removed #{count} member records"
  end

  task :import_state_records => :environment do
    puts "importing new state records"
    states = CSV.table("know_who/States.utf8.csv")
    states.each do |state|
      s = State.new
      s.code = state[:statepostcode]
      s.name = state[:statename]
      if State.us_codes.include?(s.code)
        s.is_state = true
        puts "Added state #{state[:statepostcode]} - #{state[:statename]}"
      else
        s.is_state = false
        puts "Added non-state #{state[:statepostcode]} - #{state[:statename]}"
      end
      s.save!
    end
  end

  task :import_member_records => :environment do
    puts "importing new member records"
    ["know_who/Members-State.utf8.csv", "know_who/Members-Fed.utf8.csv"].each do |member_file|
      CSV.foreach(member_file, headers: true, header_converters: :symbol) do |know_who_member|
        member = MemberImporter.create_or_update(know_who_member)
        puts "Imported #{member.prefix_name}"
      end
    end
  end

  task :import_bio_records => :environment do
    begin
      CSV.foreach("know_who/Biographies.utf8.csv", headers: true, header_converters: :symbol) do |bio|
        #member = Member.first(conditions: { person_id: bio[:pid] })
        #member.update_attributes(
        #  biography: bio[:document],
        #  biography_updated_on: bio[:biodate],
        #)
        print "."
        #puts "Updated bio for #{member.name}"
        #sleep 3
        @bio = bio
      end
    rescue
      puts "Error on bio for #{@bio[:pid]}"
    end 
  end

  task :setup_files => :environment do
    `iconv -c -f ASCII -t UTF8 know_who/raw/State_Leg_L1_*_CSV/Biographies.csv > ~/code/psp/know_who/Biographies.utf8.csv`
    `iconv -c -f ASCII -t UTF8 know_who/raw/State_Leg_L1_*_CSV/Members.csv > ~/code/psp/know_who/Members-State.utf8.csv`
    `iconv -c -f ASCII -t UTF8 know_who/raw/State_Leg_L1_*_CSV/States.csv > ~/code/psp/know_who/States.utf8.csv`
    `iconv -c -f ASCII -t UTF8 know_who/raw/Fed_Leg_L1_*_CSV/Members.csv > ~/code/psp/know_who/Members-Fed.utf8.csv`
    `fromdos know_who/*.csv`
  end
end
