xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Public Servants' Prayer Daily Calendar"
    xml.description "A Daily update of #{@state.name} legislators we are praying for" 
    xml.link "http://publicservantsprayer.org/states/#{params[:state_id]}/feed.rss"
      xml.item do
        xml.link state_date_url(params[:id], @date.year, @date.month, @date.day)
        xml.guid state_date_url(params[:id], @date.year, @date.month, @date.day)
        #xml.title "Please pray today for: #{@member0.prefix_name}, #{@member1.prefix_name}, #{@member2.prefix_name}"
        xml.pubDate ((@date.to_time) + 9.hours).to_s(:rfc822)
        xml.description do
          xml.cdata!(render(partial: "email_rss.html.erb"))
        end
    end
  end
end
