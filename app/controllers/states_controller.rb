class StatesController < ApplicationController

  def index
    render layout: "application"
  end

  def show
    unless params[:year].blank?
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    else
      @date = Date.today
    end
    @state = State.find(params[:id])
    @member0 = @state.member_zero(@date)
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)

    respond_to do |format|
      format.html
      format.pdf do
        @sunday = @date.next_week.next_day(6)
        render pdf: "calendar.pdf",
          orientation: "Landscape"
      end
    end
  end

  def daily_twitter_feed
    @date = Date.today
    @state = State.find(params[:state_id])
    @member0 = @state.member_zero(@date)
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
    end
  end

  def daily_email_feed
    @date = Date.today
    @state = State.find(params[:state_id])
    @member0 = @state.member_zero(@date)
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)

    respond_to do |format|
      format.rss { render :layout => false } #index.rss.builder
    end
  end

  def weekly_email_feed
    @date = Date.today
    @sunday = @date.next_week.next_day(6)
    @state = State.find(params[:state_id])

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end
end
