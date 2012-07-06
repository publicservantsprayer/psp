module StatesHelper

  def member_data_tr(member_field, member_label)
    unless member_field.blank?
      str =  "<tr>"
      str += "<th>#{member_label}</th>"
      str += "<td>#{member_field}</td>"
      str += "</tr>"
      str.html_safe
    end
  end
end
