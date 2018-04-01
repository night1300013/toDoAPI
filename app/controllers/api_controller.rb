class ApiController < ApplicationController
  #skip_before_action :verify_authenticity_token#, raise: false
  private
  def authenticated?
    authenticate_or_request_with_http_basic do |email, password|
      User.where( email: email, password_digest: password).present? }
    end
  end
end
