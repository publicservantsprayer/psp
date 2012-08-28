class SubscriptionsController < ApplicationController
  layout "states"

  def create
    @state = State.find(params[:state_id])
    @subscription = Subscription.new(params[:subscription])
    if @subscription.valid?
      if @subscription.save
        flash[:success] = "You have successfully subscribed to the #{@subscription.calendar_name}"
      else
        flash[:warning] = "Your subscription could not be created."
        @subscription.mail_chimp_errors.each do |error|
          unless Rails.env == "production"
            flash[:error] += error
          end
          logger.fatal error 
        end
      end
      redirect_to state_calendar_path(@state.to_param, @subscription.calendar_id)
    else
      flash[:error] = "There is a problem with your email."
      render "calendars/show"
    end
  end
end
