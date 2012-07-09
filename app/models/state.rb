class State
  include Mongoid::Document
  has_many :members do
    def state
      where(legislator_type: "SL").ascending(:district)
    end

    def state_house
      where(legislator_type: "SL", chamber: "H").ascending(:district)
    end

    def state_senate
      where(legislator_type: "SL", chamber: "S").ascending(:district)
    end

    def us
      where(legislator_type: "FL").ascending(:district)
    end

    def us_house
      where(legislator_type: "FL", chamber: "H").ascending(:district)
    end

    def us_senate
      where(legislator_type: "FL", chamber: "S").ascending(:district)
    end

  end

  field :code, type: String
  field :name, type: String
  field :pointer_zero, type: Integer, default: 0
  field :pointer_one, type: Integer, default: 0
  field :pointer_two, type: Integer, default: 1
  field :last_incremented_on, type: Date, default: -> { Date.today }

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
    if dual_chamber?
      increment_dual_chamber
    else
      increment_single_chamber
    end
    update_attribute(:last_incremented_on, Date.today)
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
      pointer = pointer - count 
    end
    self.members.state[pointer]
  end

  def single_chamber_two(date)
    count = self.members.state.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.state[pointer]
  end

  def us_member(date)
    count = self.members.us.count
    number_of_days = date - Date.today 
    pointer = pointer_zero + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.us[pointer]
  end

  def state_senate_member(date)
    count = self.members.state_senate.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.state_senate[pointer]
  end

  def state_house_member(date)
    count = self.members.state_house.count
    number_of_days = date - Date.today 
    pointer = pointer_one + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.state_house[pointer]
  end

end
