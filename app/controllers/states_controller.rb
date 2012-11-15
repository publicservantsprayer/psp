class StatesController < ApplicationController

  def index
    render layout: "application"
  end

  def show
    cookies[:state_code] = params[:id]
    @state = UsState.new(params[:id])
    @date = build_date
    @leaders = LeaderSelector.for_day(@state, @date)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #show.rss.builder
    end
  end

  def twitter
    @state = UsState.new(params[:id])
    @date = build_date
    @leaders = LegislatorSelector.for_day(@state, @date)

    respond_to do |format|
      format.rss { render :layout => false } #twitter.rss.builder
    end
  end

  def email
    @state = UsState.new(params[:id])
    @date = build_date
    @leaders = LegislatorSelector.for_day(@state, @date)

    render layout: false
  end

  private

    def build_date
      year = params[:year] || Date.current.year
      month = params[:month] || Date.current.month
      day = params[:day] || Date.current.day
      Date.new(year.to_i, month.to_i, day.to_i)
    end
end
