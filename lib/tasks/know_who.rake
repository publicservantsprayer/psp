require 'csv'

namespace :know_who do
  task :download_latest_data do
    `mkdir -p know_who/raw`
    `cd know_who/raw && wget ftp://ftp_capitolcomm:ktr84sbe@205.134.170.180/* `
    `cd know_who/raw && unzip *.zip`
  end

  task :delete_existing_data => :environment do
    puts "removing old state data"
    count = State.delete_all
    puts "removed #{count} state records"

    puts "removing old member data"
    count = Member.delete_all
    puts "removed #{count} member records"
  end

  task :import_state_records => :environment do
    puts "importing new state records"
    states = CSV.table("know_who/States.utf8.csv")
    states.each do |state|
      State.create(
        code: state[:statepostcode],
        name: state[:statename],
      )
      puts "Added #{state[:statename]}"
    end
  end

  task :import => :environment do
    Rake::Task["know_who:setup_files"].execute
    Rake::Task["know_who:import_state_records"].execute
    Rake::Task["know_who:import_member_records"].execute
    Rake::Task["know_who:import_bio_records"].execute
  end

  task :import_member_records => :environment do
    legacy_fields = ["UID","PID","LEGTYPE","CHAMBER","CHAMBERANK","STATECODE","STATE","DISTRICT","DISTRAIL","DISTYPE","PARTYRANK","PERCENTVOT","ELECTDATE","REELECTYR","ELECTCODE","FECLINK","PYRACUSC","CYRACUSC","PYRADASC","CYRADASC","PYRAFLSC","CYRAFLSC","PYRUSCOSC","CYRUSCOSC","SEATSTCODE","SEATSTAT","DISTRICTID","SEATID","PARTYCODE","FIRSTNAME","LASTNAME","MIDNAME","NICKNAME","PREFIX","GENSUFFIX","TITLE","PROFSUFFIX","GENDER","LEGALNAME","PRONUNCTON","BIRTHPLACE","BIRTHYEAR","BIRTHMONTH","BIRTHDATE","MARITAL","SPOUSE","RESIDENCE","FAMILY","RELIGCODE","RELIGION","ETHCODE","ETHNICS","REOFC1","REOFC1DATE","REOFC2","REOFC2DATE","RECOCCODE1","RECENTOCC1","RECOCCODE2","RECENTOCC2","SCHOOL1","DEGREE1","EDUDATE1","SCHOOL2","DEGREE2","EDUDATE2","SCHOOL3","DEGREE3","EDUDATE3","MILBRANCH1","MILRANK1","MILDATES1","MILBRANCH2","MILRANK2","MILDATES2","MAILNAME","MAILTITLE","MAILADDR1","MAILADDR2","MAILADDR3","MAILADDR4","MAILADDR5","EMAIL","WEBFORM","WEBSITE","WEBLOG","FACEBOOK","TWITTER","YOUTUBE","PHOTOPATH","PHOTOFILE"]

    puts "importing new member records"
    ["know_who/Members-State.utf8.csv", "know_who/Members-Fed.utf8.csv"].each do |member_file|
      CSV.foreach(member_file, headers: true, header_converters: :symbol) do |member|
        state = State.first(conditions: { code: member[:statecode] })
        if state
          new_member = state.members.new(
            person_id: member[:pid],
            legislator_type: member[:legtype],
            title: member[:title],
            first_name: member[:firstname],
            last_name: member[:lastname],
            mid_name: member[:midname],
            nick_name: member[:nickname],
            legal_name: member[:legalname],
            state: member[:state],
            party_code: member[:partycode],
            district: member[:district],
            district_id: member[:districtid],
            family: member[:family],
            religion: member[:religion],
            email: member[:email],
            website: member[:website],
            webform: member[:webform],
            weblog: member[:weblog],
            blog: member[:weblog],
            facebook: member[:facebook],
            twitter: member[:twitter],
            youtube: member[:youtube],
            photo_path: member[:photopath],
            photo_file: member[:photofile],
            chamber: member[:chamber],
            gender: member[:gender],
            party_code: member[:partycode],
            birth_place: member[:birthplace],
            birth_year: member[:birthyear],
            birth_month: member[:birthmonth],
            birth_day: member[:birthday],
            spouse: member[:spouse],
            marital_status: member[:marital],
            residence: member[:residence],
            school_1_name: member[:school1],
            school_1_date: member[:edudate1],
            school_1_degree: member[:degree1],
            school_2_name: member[:school2],
            school_2_date: member[:edudate2],
            school_2_degree: member[:degree2],
            school_3_name: member[:school3],
            school_3_date: member[:edudate3],
            school_3_degree: member[:degree3],
            military_1_branch: member[:milbranch1],
            military_1_rank: member[:milrank1],
            military_1_dates: member[:mildates1],
            military_2_branch: member[:milbranch2],
            military_2_rank: member[:milrank2],
            military_2_dates: member[:mildates2],
            mail_name: member[:mailname],
            mail_title: member[:mailtitle],
            mail_address_1: member[:mailaddr1],
            mail_address_2: member[:mailaddr2],
            mail_address_3: member[:mailaddr3],
            mail_address_4: member[:mailaddr4],
            mail_address_5: member[:mailaddr5]
          )
          legacy_fields.each do |field|
            field = field.downcase.to_sym
            attribute = "legacy_#{field}".to_sym
            new_member[attribute] = member[field]
          end
          new_member.save!
          puts "#{new_member.first_name} #{new_member.last_name} (#{state.name}), "
        else
          puts "no state found"
        end
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
