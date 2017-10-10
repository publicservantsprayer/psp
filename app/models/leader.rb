class Leader < Hashie::Mash
  disable_warnings

  def setup(data)
    data.each do |key, value|
      self[key] = value
    end
  end

  def state
    UsState.new(state_code)
  end

  def birthday
    unless born_on.blank?
      Date.parse(born_on).strftime("%B %e")
    else
      ""
    end
  end

  def district_residence
    [district, residence].reject{|i|i.blank?}.join(" - ")
  end

  def name
    self['name'] || ""
  end

  def title
    self['title'] || ""
  end

  def email
    self['email'] || ""
  end

  def photo_src
    self['photo_src'] || "placeholder.jpg"
  end

  def twitter_or_name
    return name if twitter.blank?
    twitter_handle
  end

  private

  def twitter_handle
    "@#{twitter.split('/').last}"
  end
end

