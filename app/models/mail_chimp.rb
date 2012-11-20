class MailChimp

  def list_id
    ENV['MC_LIST_ID']
  end

  def segments
    mc('list_static_segments') 
  end

  def members
    mc('list_members')
  end

  def create_segment(segment)
    mc('list_static_segment_add', name: segment.name)
  end

  def delete_segment(segment)
    mc('list_static_segment_del', seg_id: segment.mail_chimp_id)
  end

  def subscribe_to_segment(email, segment, merge_vars)
    subscribe(email, merge_vars)
    add_to_segment(email, segment)
  end

  def subscribe(email, merge_vars)
    mc('list_subscribe', {
      email_address: email,
      merge_vars: merge_vars,
      double_optin: false,
      update_existing: true,
      send_welcome: true
      })
  end

  def add_to_segment(email, segment)
    mc('list_static_segment_members_add', 
       seg_id: segment.mail_chimp_id,
       batch: [email]
      )
  end

  private

    def mc(message, args={})
      Gibbon.new.send(message, {id: list_id}.merge(args))
    end

end
