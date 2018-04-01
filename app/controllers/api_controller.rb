class ApiController < ApplicationController
  #skip_before_action :verify_authenticity_token#, raise: false
  private
  def authenticated?
    authenticate_or_request_with_http_basic do |username, password|
      resource = User.find_by_email(username)
      if resource&.valid_password?(password)
        sign_in :user, resource
      else
        #head :unauthorized, :status => :bad_request
        render json: "username or password not correct!\n", status: 401
      end
      #User.where( email: email, password_digest: password).present? }
    end
  end
end
