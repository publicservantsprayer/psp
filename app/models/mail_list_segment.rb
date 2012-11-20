class MailListSegment
  attr_accessor :state, :cycle

  def initialize(state, cycle)
    @state = state
    @cycle = cycle
  end

  def name
    "#{cycle.titlecase}-#{state.code.upcase}-#{state.name}"
  end

  def public_name
    "#{state.name} #{cycle} Prayer List".titlecase
  end

  def state_code
    @state.code
  end

  def create
    MailChimp.new.create_segment(self)
  end

  def mail_chimp_id(segments=nil)
    segments = MailChimp.new.segments unless segments
    name_ids = {}
    segments.each do |segment|
      name_split = segment['name'].split('-')
      seg_cycle = name_split[0].downcase
      seg_state_code = name_split[1].downcase
      seg_name = [seg_state_code, seg_cycle].join('-')
      name_ids[seg_name] = segment['id']
    end
    name_ids[[state_code.downcase, cycle.downcase].join('-')]
  end
end
