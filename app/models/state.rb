class State < ActiveRecord::Base
  has_many :members 
  extend FriendlyId
  friendly_id :code, use: :slugged

  scope :fifty, where(is_state: true).order(:name)
  scope :northeast, where(region: "NE").order(:name)
  scope :midwest, where(region: "MW").order(:name)
  scope :south, where(region: "S").order(:name)
  scope :west, where(region: "W").order(:name)

  before_create :set_last_incremented_on_to_today
  def set_last_incremented_on_to_today
    write_attribute :last_incremented_on, Date.today
  end

  def code_downcase
    code.downcase
  end

  def self.find_by_ip(ip)
    require 'geoip'
    db = GeoIP::City.new('geoip/GeoLiteCity.dat')
    result = db.look_up(ip)
    where(code: result[:region]).first
  end

  # state only
  def dual_chamber?
    if code == "DC"
      false
    elsif self.members.state_house.count < 1 or self.members.state_senate.count < 1
      false
    else
      true
    end
  end

  def verify_incremented
    if last_incremented_on < Date.today
      increment_pointers
    end
  end

  def increment_pointers
    update_attribute(:last_incremented_on, Date.today)
    if dual_chamber?
      increment_dual_chamber
    else
      increment_single_chamber
    end
  end

  def increment_single_chamber
    write_attribute(:pointer_zero, (pointer_zero + 1))
    write_attribute(:pointer_one, (pointer_one + 2))
    write_attribute(:pointer_two, (pointer_two + 2))
    if pointer_zero >= self.members.us.count
      write_attribute(:pointer_zero, (pointer_zero - self.members.us.count))
    end
    if pointer_one >= (self.members.state.count - 2)
      write_attribute(:pointer_one, (pointer_one - self.members.state.count))
    end
    if pointer_two >= (self.members.state.count - 1)
      write_attribute(:pointer_two, (pointer_two - self.members.state.count))
    end
    save!
  end

  def increment_dual_chamber
    write_attribute(:pointer_zero, (pointer_zero + 1))
    write_attribute(:pointer_one, (pointer_one + 1))
    write_attribute(:pointer_two, (pointer_two + 1))
    if pointer_zero >= self.members.us.count
      write_attribute(:pointer_zero, (pointer_zero - self.members.us.count))
    end
    if pointer_one >= self.members.state_house.count
      write_attribute(:pointer_one, (pointer_one - self.members.state_house.count))
    end
    if pointer_two >= self.members.state_senate.count
      write_attribute(:pointer_two, (pointer_two - self.members.state_senate.count))
    end
    save!
  end

  def member_zero(date)
    return false if date < Date.today
    verify_incremented
    us_member(date)
  end

  def member_one(date)
    return false if date < Date.today
    verify_incremented
    if dual_chamber?
      state_senate_member(date)
    else
      single_chamber_one(date)
    end
  end

  def member_two(date)
    return false if date < Date.today
    verify_incremented
    if dual_chamber?
      state_house_member(date)
    else
      single_chamber_two(date)
    end
  end

  def single_chamber_one(date)
    count = self.members.state.count
    number_of_days = date - Date.today 
    pointer = pointer_one + number_of_days
    while pointer >= count
      break if count < 1
      pointer = pointer - count 
    end
    self.members.state.order(:district)[pointer]
  end

  def single_chamber_two(date)
    count = self.members.state.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      break if count < 1
      pointer = pointer - count 
    end
    self.members.state.order(:district)[pointer]
  end

  def us_member(date)
    count = self.members.us.count
    number_of_days = date - Date.today 
    pointer = pointer_zero + number_of_days
    while pointer >= count
      break if count < 1
      pointer = pointer - count 
    end
    self.members.us.order(:district)[pointer]
  end

  def state_senate_member(date)
    count = self.members.state_senate.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      break if count < 1
      pointer = pointer - count 
    end
    self.members.state_senate.order(:district)[pointer]
  end

  def state_house_member(date)
    count = self.members.state_house.count
    number_of_days = date - Date.today 
    pointer = pointer_one + number_of_days
    while pointer >= count
      break if count < 1
      pointer = pointer - count 
    end
    self.members.state_house.order(:district)[pointer]
  end

  def self.us_codes
    ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
  end

  # Currently unused
  def self.us_names
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

end
