class CalendarsController < ApplicationController
  layout "states"

  def index

  end

  def show
    @state = State.find(params[:state_id])
    @subscription = Subscription.new(
      calendar_id: params[:id], 
      state_id: params[:state_id]
    )
  end
end
