class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_ip

  def get_ip
    @client_ip = request.remote_ip
    @client_ip_forwarded = request.env["HTTP_X_FORWARDED_FOR"]
  end

end
