class StatesController < ApplicationController

  def index

  end

  def show
    unless params[:year].blank?
      @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    else
      @date = Date.today
    end
    @state = State.first(conditions: {code: params[:id].upcase}) 
    @member1 = @state.member_one(@date)
    @member2 = @state.member_two(@date)
  end
end
