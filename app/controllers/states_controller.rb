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
    if @state.multiple_chambers?
      @member1 = @state.members.senate.first
      @member2 = @state.members.house.first
    else
      @member1 = @state.members.first
      @member2 = @state.members.last
    end
  end
end
