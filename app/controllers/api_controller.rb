class ApiController < ApplicationController
  #skip_before_action :verify_authenticity_token#, raise: false
  include ActionController::Helpers
  include ActionController::HttpAuthentication::Token::ControllerMethods
  #before_action :authenticated?
  
  helper_method :user_signed_in?, :current_user

  def require_login!
    return true if authenticate_token
    render json: { errors: [ { detail: "Access denied" } ] }, status: 401
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= authenticate_token
  end

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

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.where(auth_token: token).where("token_created_at >= ?", 1.day.ago).first
    end
  end
end
