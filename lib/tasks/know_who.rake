require 'csv'

namespace :know_who do
  task :import => :environment do
    puts "removing old state data"
    count = State.delete_all
    puts "removed #{count} state records"
    puts "importing new state records"
    states = CSV.table("know_who/States.utf8.csv")
    states.each do |state|
      State.create(
        code: state[:statepostcode],
        name: state[:statename],
      )
      puts "Added #{state[:statename]}"
    end

    legacy_fields = ["UID","PID","LEGTYPE","CHAMBER","CHAMBERANK","STATECODE","STATE","DISTRICT","DISTRAIL","DISTYPE","PARTYRANK","PERCENTVOT","ELECTDATE","REELECTYR","ELECTCODE","FECLINK","PYRACUSC","CYRACUSC","PYRADASC","CYRADASC","PYRAFLSC","CYRAFLSC","PYRUSCOSC","CYRUSCOSC","SEATSTCODE","SEATSTAT","DISTRICTID","SEATID","PARTYCODE","FIRSTNAME","LASTNAME","MIDNAME","NICKNAME","PREFIX","GENSUFFIX","TITLE","PROFSUFFIX","GENDER","LEGALNAME","PRONUNCTON","BIRTHPLACE","BIRTHYEAR","BIRTHMONTH","BIRTHDATE","MARITAL","SPOUSE","RESIDENCE","FAMILY","RELIGCODE","RELIGION","ETHCODE","ETHNICS","REOFC1","REOFC1DATE","REOFC2","REOFC2DATE","RECOCCODE1","RECENTOCC1","RECOCCODE2","RECENTOCC2","SCHOOL1","DEGREE1","EDUDATE1","SCHOOL2","DEGREE2","EDUDATE2","SCHOOL3","DEGREE3","EDUDATE3","MILBRANCH1","MILRANK1","MILDATES1","MILBRANCH2","MILRANK2","MILDATES2","MAILNAME","MAILTITLE","MAILADDR1","MAILADDR2","MAILADDR3","MAILADDR4","MAILADDR5","EMAIL","WEBFORM","WEBSITE","WEBLOG","FACEBOOK","TWITTER","YOUTUBE","PHOTOPATH","PHOTOFILE"]

    puts "removing old member data"
    count = Member.delete_all
    puts "removed #{count} member records"
    puts "importing new member records"
    CSV.foreach("know_who/Members.utf8.csv", headers: true, header_converters: :symbol) do |member|
      state = State.first(conditions: { code: member[:statecode] })
      if state
        new_member = state.members.new(
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
          blog: member[:weblog],
          facebook: member[:facebook],
          twitter: member[:twitter],
          youtube: member[:youtube],
          photo_path: member[:photopath],
          photo_file: member[:photofile],
          chamber: member[:chamber]
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
