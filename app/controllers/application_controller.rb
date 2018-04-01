class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  #include ActionController::HttpAuthentication::Token::ControllerMethods
  #protect_from_forgery with: :exception
end
