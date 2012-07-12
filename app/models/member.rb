class Member < ActiveRecord::Base
  belongs_to :state

  attr_protected :person_id

  scope :state,         where(legislator_type: "SL").order(:district)
  scope :state_house,   where(legislator_type: "SL", chamber: "H").order(:district)
  scope :state_senate,  where(legislator_type: "SL", chamber: "S").order(:district)
  scope :us,            where(legislator_type: "FL").order(:district)
  scope :us_house,      where(legislator_type: "FL", chamber: "H").order(:district)
  scope :us_senate,     where(legislator_type: "FL", chamber: "S").order(:district)

  def name
    "#{nick_name} #{last_name}"
  end

  def prefix_name
    if legislator_type == "FL"
     "US #{prefix} #{name}"
    else
     "#{prefix} #{name}"
    end
  end

  def photo_src
    path = photo_path.split("\\")
    return "/assets/no_photo.gif" if path.blank? or photo_file.blank?
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
