class Member
  include Mongoid::Document
  belongs_to :state

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

  def information
    str = ""
    str += "<p>Born in #{read_attribute(:birth_place)}, " unless read_attribute(:birth_place).blank?
    str += "#{name} currently resides in #{read_attribute(:residence)}.</p>"
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
