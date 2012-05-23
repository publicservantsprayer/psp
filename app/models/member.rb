class Member
  include Mongoid::Document
  belongs_to :state

  field first_name: String
  field last_name: String
  field religion: String
  field district: String
  field family: String
  field website: String
  field facebook: String
  field email: String

  def name
    "#{nick_name} #{last_name}"
  end

  def photo_src
    path = photo_path.split("\\")
    "/#{path[1].downcase}/#{path[2]}/#{path[3]}/#{path[4]}/#{photo_file}"
  end
end
