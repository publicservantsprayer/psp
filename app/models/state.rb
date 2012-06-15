class State
  include Mongoid::Document
  has_many :members do
    def house
      where(chamber: "H").ascending(:district)
    end

    def senate
      where(chamber: "S").ascending(:district)
    end
  end

  field :code, type: String
  field :name, type: String
  field :pointer_one, type: Integer, default: 0
  field :pointer_two, type: Integer, default: 1
  field :last_incremented_on, type: Date, default: -> { Date.today }

  def dual_chamber?
    if code == "DC"
      false
    elsif self.members.house.count < 1 or self.members.senate.count < 1
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
    count = self.members.count
    write_attribute(:pointer_one, (pointer_one + 2))
    write_attribute(:pointer_two, (pointer_two + 2))
    if pointer_one >= (count - 2)
      write_attribute(:pointer_one, (pointer_one - count))
    end
    if pointer_two >= (count - 1)
      write_attribute(:pointer_two, (pointer_two - count))
    end
    save!
  end

  def increment_dual_chamber
    write_attribute(:pointer_one, (pointer_one + 1))
    write_attribute(:pointer_two, (pointer_two + 1))
    if pointer_one >= self.members.house.count
      write_attribute(:pointer_one, (pointer_one - self.members.house.count))
    end
    if pointer_two >= self.members.senate.count
      write_attribute(:pointer_two, (pointer_two - self.members.senate.count))
    end
    save!
  end

  def member_one(date)
    return false if date < Date.today
    verify_incremented
    if dual_chamber?
      house_member(date)
    else
      single_chamber_one(date)
    end
  end

  def member_two(date)
    return false if date < Date.today
    verify_incremented
    if dual_chamber?
      senate_member(date)
    else
      single_chamber_two(date)
    end
  end

  def single_chamber_one(date)
    count = self.members.count
    number_of_days = date - Date.today 
    pointer = pointer_one + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members[pointer]
  end

  def single_chamber_two(date)
    count = self.members.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members[pointer]
  end

  def house_member(date)
    count = self.members.house.count
    number_of_days = date - Date.today 
    pointer = pointer_one + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.house[pointer]
  end

  def senate_member(date)
    count = self.members.senate.count
    number_of_days = date - Date.today 
    pointer = pointer_two + number_of_days
    while pointer >= count
      pointer = pointer - count 
    end
    self.members.senate[pointer]
  end

end
