xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Public Servants' Prayer Daily Calendar"
    xml.description "A Daily update of #{@state.name} legislators we are praying for" 
    xml.link "http://www.publicservantsprayer.org/states/#{params[:id]}/feed.rss"
    xml.item do
      xml.link daily_calendar_url(params[:id], @date.year, @date.month, @date.day)
      xml.guid daily_calendar_url(params[:id], @date.year, @date.month, @date.day)
      xml.pubDate ((@date.to_time) + 9.hours).to_s(:rfc822)
      xml.title "Please pray today for: #{@leaders[0].twitter_or_name}, #{@leaders[1].twitter_or_name}, #{@leaders[2].twitter_or_name}"
    end
  end
end
