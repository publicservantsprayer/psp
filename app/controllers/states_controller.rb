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
    @state = State.find_by_code(params[:id].upcase)
    @member0 = @state.member_zero(@date)
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)
  end

  def feed
    @date = Date.today
    @state = State.find_by_code(params[:id].upcase)
    @member0 = @state.member_zero(@date)
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)

    respond_to do |format|
      format.html
      format.rss { render :layout => false } #index.rss.builder
    end
  end
end
