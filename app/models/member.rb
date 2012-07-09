class Member
  include Mongoid::Document
  belongs_to :state

  field :legislator_type, type: String
  field :title, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :nick_name, type: String
  field :gender, type: String
  field :photo_path, type: String
  field :photo_file, type: String
  field :religion, type: String
  field :chamber, type: String
  field :district, type: String
  field :family, type: String
  field :website, type: String
  field :facebook, type: String
  field :email, type: String
  field :party_code, type: String
  field :twitter, type: String
  field :birth_place, type: String
  field :birth_month, type: String
  field :birth_day, type: String
  field :spouse, type: String
  field :marital, type: String
  field :residence, type: String
  field :school_1_name, type: String
  field :school_1_date, type: String
  field :school_1_degree, type: String
  field :school_2_name, type: String
  field :school_2_date, type: String
  field :school_2_degree, type: String
  field :school_3_name, type: String
  field :school_3_date, type: String
  field :school_3_degree, type: String
  field :military_1_branch, type: String
  field :military_1_rank, type: String
  field :military_1_dates, type: String
  field :military_2_branch, type: String
  field :military_2_rank, type: String
  field :military_2_dates, type: String
  field :mail_name, type: String
  field :mail_title, type: String
  field :mail_address_1, type: String
  field :mail_address_2, type: String
  field :mail_address_3, type: String
  field :mail_address_4, type: String
  field :mail_address_5, type: String

  def name
    "#{nick_name} #{last_name}"
  end

  def photo_src
    path = photo_path.split("\\")
    "/#{path[1].downcase}/#{path[2]}/#{path[3]}/#{path[4]}/#{photo_file}"
  end

  def birth_month_name
    month = read_attribute(:birth_month).to_i
    Date::MONTHNAMES[month]
  end

  def birthday
    unless read_attribute(:birth_day).blank?
      "#{birth_month_name}, #{read_attribute(:birth_day).to_i.ordinalize}"
    end
  end

  def born
    unless read_attribute(:birth_place).blank?
      unless birth_month_name.blank?
        unless read_attribute(:birth_day).blank?
          "Born in #{read_attribute(:birth_place)} on #{birth_month_name}, #{read_attribute(:birth_day).to_i.ordinalize}"
        else
          "Born in #{read_attribute(:birth_place)} in the month of #{birth_month_name}"
        end
      else
        "Born in #{read_attribute(:birth_place)}"
      end
    else
      unless birth_month_name.blank?
        unless read_attribute(:birth_day).blank?
          "Born on #{birth_month_name}, #{read_attribute(:birth_day).to_i.ordinalize}"
        else
          "Born in #{birth_month_name}"
        end
      else
        ""
      end
    end
  end

  def school
    str = ""
    unless read_attribute(:school_1_name).blank?
      unless read_attribute(:school_1_degree).blank?
        str += "#{read_attribute(:school_1_degree)} from "
      end
      str += "#{read_attribute(:school_1_name)}"
      unless read_attribute(:school_1_date).blank?
        str += " (#{read_attribute(:school_1_date)})"
      end
    end
    unless read_attribute(:school_2_name).blank?
      str += "\n\n"
      unless read_attribute(:school_2_degree).blank?
        str += "#{read_attribute(:school_2_degree)} from "
      end
      str += "#{read_attribute(:school_2_name)}"
      unless read_attribute(:school_2_date).blank?
        str += " (#{read_attribute(:school_2_date)})"
      end
    end
    unless read_attribute(:school_3_name).blank?
      str += "\n\n"
      unless read_attribute(:school_3_degree).blank?
        str += "#{read_attribute(:school_3_degree)} from "
      end
      str += "#{read_attribute(:school_3_name)}"
      unless read_attribute(:school_3_date).blank?
        str += " (#{read_attribute(:school_3_date)})"
      end
    end
    str
  end

  def military
    str = ""
    unless read_attribute(:military_1_branch).blank?
      unless read_attribute(:military_1_rank).blank?
        str += "#{read_attribute(:military_1_rank)} in the "
      end
      str += "#{read_attribute(:military_1_branch)}"
      unless read_attribute(:military_1_dates).blank?
        str += " from #{read_attribute(:military_1_dates)}"
      end
    end
    str
  end

  def family_info
    "#{read_attribute(:spouse)}\n#{read_attribute(:family)}".strip
  end


  def mailing_address
    "#{read_attribute(:mail_name)}\n#{read_attribute(:mail_title)}\n" +
    "#{read_attribute(:mail_address_1)}\n#{read_attribute(:mail_address_2)}\n" +
    "#{read_attribute(:mail_address_3)}\n#{read_attribute(:mail_address_4)}".strip 
  end

  def information
    str = "<p>"
    unless read_attribute(:birth_place).blank?
      str += "Born in #{read_attribute(:birth_place)}, "
    end
    unless read_attribute(:residence).blank?
      str += "#{name} currently resides in #{read_attribute(:residence)}."
    end
    unless read_attribute(:military_1_branch).blank?
      str += "<p>He served as a #{read_attribute(:military_1_rank)} "
      str += "in the #{read_attribute(:military_1_branch)} "
      str += "from #{read_attribute(:military_1_dates)}.</p>"
    end
    unless read_attribute(:military_2_branch).blank?
      str += "<p>He also served as a #{read_attribute(:military_2_rank)} "
      str += "in the #{read_attribute(:military_2_branch)} "
      str += "from #{read_attribute(:military_2_dates)}.</p>"
    end
    str.html_safe
  end
end
