class MemberImporter
  attr_accessor :state, :member
  
  def self.create_or_update(know_who_data)
    import = MemberImporter.new(know_who_data)

    if import.member_exists?
      import.member = Member.find_by_person_id(know_who_data[:pid])
      if import.member.state.code != import.state.code
        raise "Know Who data tried to change member state"
      end
    else
      import.member = import.state.members.create
      import.member.update_attribute(:person_id, know_who_data[:pid])
    end
    import.update_attributes_from_know_who
    import.member
  end

  def initialize(know_who_data)
    @know_who_data = know_who_data
    @state = State.find_by_code(data[:statecode])
    unless @state 
      puts "the following state could not be found:"
      puts data[:statecode]
      raise "Know Who data state not found"
    end
  end

  def data
    @know_who_data
  end

  def member_exists?
    Member.where(person_id: data[:pid]).exists?
  end

  # From the Know Who DB
  def legacy_fields
    ["UID","PID","LEGTYPE","CHAMBER","CHAMBERANK","STATECODE","STATE","DISTRICT","DISTRAIL","DISTYPE","PARTYRANK","PERCENTVOT","ELECTDATE","REELECTYR","ELECTCODE","FECLINK","PYRACUSC","CYRACUSC","PYRADASC","CYRADASC","PYRAFLSC","CYRAFLSC","PYRUSCOSC","CYRUSCOSC","SEATSTCODE","SEATSTAT","DISTRICTID","SEATID","PARTYCODE","FIRSTNAME","LASTNAME","MIDNAME","NICKNAME","PREFIX","GENSUFFIX","TITLE","PROFSUFFIX","GENDER","LEGALNAME","PRONUNCTON","BIRTHPLACE","BIRTHYEAR","BIRTHMONTH","BIRTHDATE","MARITAL","SPOUSE","RESIDENCE","FAMILY","RELIGCODE","RELIGION","ETHCODE","ETHNICS","REOFC1","REOFC1DATE","REOFC2","REOFC2DATE","RECOCCODE1","RECENTOCC1","RECOCCODE2","RECENTOCC2","SCHOOL1","DEGREE1","EDUDATE1","SCHOOL2","DEGREE2","EDUDATE2","SCHOOL3","DEGREE3","EDUDATE3","MILBRANCH1","MILRANK1","MILDATES1","MILBRANCH2","MILRANK2","MILDATES2","MAILNAME","MAILTITLE","MAILADDR1","MAILADDR2","MAILADDR3","MAILADDR4","MAILADDR5","EMAIL","WEBFORM","WEBSITE","WEBLOG","FACEBOOK","TWITTER","YOUTUBE","PHOTOPATH","PHOTOFILE"]
  end


  def update_attributes_from_know_who
    unless data[:birthyear].blank? or data[:birthmonth].blank? or data[:birthday].blank?
      birthday = Date.new(date[:birthyear].to_i, data[:birthmonth].to_i, data[:birthday].to_i)
    else
      birthday = nil
    end
    @member.born_on = birthday
    @member.legislator_type = data[:legtype]
    @member.title = data[:title]
    @member.prefix = data[:prefix]
    @member.first_name = data[:firstname]
    @member.last_name = data[:lastname]
    @member.mid_name = data[:midname]
    @member.nick_name = data[:nickname]
    @member.legal_name = data[:legalname]
    @member.party_code = data[:partycode]
    @member.district = data[:district]
    @member.district_id = data[:districtid]
    @member.family = data[:family]
    @member.religion = data[:religion]
    @member.email = data[:email]
    @member.website = data[:website]
    @member.webform = data[:webform]
    @member.weblog = data[:weblog]
    @member.blog = data[:weblog]
    @member.facebook = data[:facebook]
    @member.twitter = data[:twitter]
    @member.youtube = data[:youtube]
    @member.photo_path = data[:photopath]
    @member.photo_file = data[:photofile]
    @member.chamber = data[:chamber]
    @member.gender = data[:gender]
    @member.party_code = data[:partycode]
    @member.birth_place = data[:birthplace]
    @member.spouse = data[:spouse]
    @member.marital_status = data[:marital]
    @member.residence = data[:residence]
    @member.school_1_name = data[:school1]
    @member.school_1_date = data[:edudate1]
    @member.school_1_degree = data[:degree1]
    @member.school_2_name = data[:school2]
    @member.school_2_date = data[:edudate2]
    @member.school_2_degree = data[:degree2]
    @member.school_3_name = data[:school3]
    @member.school_3_date = data[:edudate3]
    @member.school_3_degree = data[:degree3]
    @member.military_1_branch = data[:milbranch1]
    @member.military_1_rank = data[:milrank1]
    @member.military_1_dates = data[:mildates1]
    @member.military_2_branch = data[:milbranch2]
    @member.military_2_rank = data[:milrank2]
    @member.military_2_dates = data[:mildates2]
    @member.mail_name = data[:mailname]
    @member.mail_title = data[:mailtitle]
    @member.mail_address_1 = data[:mailaddr1]
    @member.mail_address_2 = data[:mailaddr2]
    @member.mail_address_3 = data[:mailaddr3]
    @member.mail_address_4 = data[:mailaddr4]
    @member.mail_address_5 = data[:mailaddr5]
    @member.save!
  end
end
