class LegislatorSelector
  attr_accessor :state_code, :date

  ROTATE_SINCE = Date.new(2012, 1, 1)

  def initialize(state, date)
    @state_code = state.to_param
    @date = date
  end

  def self.for_day(state, date)
    selected = self.new(state, date)
    selected.select_all_legislators
  end

  def us_congress
    rotation_select('us_congress')
  end

  def state_senate
    rate = (@state_code == 'ne' ? 2 : 1)
    rotation_select('state_senate', rate)
  end

  def state_house
    rotation_select('state_house', 1)
  end

  def leader_type
    "Legislator"
  end

  def select_all_legislators
    selected_items(legislators, 3)
  end

  private

    def legislators 
      LeaderFinder.by_state(@state_code)
    end

    def rotation_select(chamber, rate=1)
      name = "#{@state_code}_#{chamber}"
      leaders = LeaderFinder.send(chamber, @state_code)
      selected_items(leaders, rate)
    end

    def selected_items(leaders, rate)
      ItemRotator.new(
        items: leaders, 
        rate: rate,
        rotations: number_of_days).selected_items
    end

    def number_of_days
      DateRange.new(
        start_date: ROTATE_SINCE,
        end_date: date).non_edge_days_between
    end
end
