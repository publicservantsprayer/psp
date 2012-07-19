class Subscription
  include ActiveModel::Validations

  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  attr_accessor :email, :name, :state_id, :calendar_id, :mail_chimp_error

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def calendar_name
    "#{state.name} #{calendar_id.titlecase} Prayer Calendar"
  end

  def self.mail_chimp
    @mail_chimp ||= Gibbon.new(ENV['MAIL_CHIMP_API_KEY'])
  end
  def mail_chimp
    @mail_chimp ||= Gibbon.new(ENV['MAIL_CHIMP_API_KEY'])
  end

  def self.psp_list
    'e9b2946252'
  end
  def psp_list
    'e9b2946252'
  end

  def mail_chimp_errors
    @mail_chimp_errors ||= []
  end

  def state
    @state ||= State.find(state_id)
  end

  def segment_id
    if calendar_id == "daily"
      return state.daily_segment_id
    elsif calendar_id == "weekly"
      return state.weekly_segment_id
    else
      raise "Incorrect calendar_id: #{calendar_id}?"
    end
  end


  def save
    return true if Rails.env == "test"
    result = subscribe_to_list
    unless result == true
      mail_chimp_errors << result["error"]
      return false
    end
    result = add_to_segment
    unless result['success'] == 1
      result["errors"].each do e
        mail_chimp_errors << e
      end
      return false
    end
    true
  end

  def subscribe_to_list
    mail_chimp.list_subscribe({
      id: psp_list,
      email_address: email,
      merge_vars: {"NAME" => name},
      double_optin: false,
      update_existing: true,
      send_welcome: true
    })
  end

  def add_to_segment
    mail_chimp.list_static_segment_members_add({
      id: psp_list,
      seg_id: segment_id,
      batch: [email]
    })
  end

  def self.set_up_segments
    static_segments.each do |segment|
      update_segment(segment)
    end
  end

  def self.static_segments
    @static_segments ||= mail_chimp.list_static_segments({ "id" => psp_list })
  end

  def self.update_segment(segment)
    segment_id = segment["id"]
    calendar_id = segment["name"].split('-')[0].downcase
    state_id = segment["name"].split('-')[1].downcase
    State.find(state_id).update_attribute("#{calendar_id}_segment_id", segment_id)
  end

  def to_model
    self
  end

  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def new_record?() true end
  def destroyed?()  true end
  def persisted?()  false end
end
