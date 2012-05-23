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

  def multiple_chambers?
    if code == "DC"
      false
    elsif self.members.house.count < 1 or self.members.senate.count < 1
      false
    else
      true
    end
  end
end
