class Api::SessionsController < ApiController
  before_action :require_login!, except: [:create]

  def create
    resource = User.find_for_database_authentication(email: params[:user_login][:email])
    resource ||= User.new

    if resource.valid_password?(params[:user_login][:password])
      auth_token = resource.generate_auth_token
      render json: { auth_token: auth_token }
    else
      invalid_login_attempt
    end

  end

  def destroy
    resource = current_user
    resource.invalidate_auth_token
    head :ok
  end

  private
  def invalid_login_attempt
    render json: { errors: [ { detail:"Error with your login or password" }]}, status: 401
  end

end
