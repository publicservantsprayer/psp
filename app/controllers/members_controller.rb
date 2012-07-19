class MembersController < ApplicationController
  layout "states"

  def index
    @state = State.find_by_code(params[:state_id].upcase)
  end

  def show
    @state = State.find_by_code(params[:state_id].upcase)
    @leader = Member.find(params[:id])
  end

end
