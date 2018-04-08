class Api::UsersController < ApiController
  before_action :require_login!, except: [:create]
  before_action :authorize_user, except: [:create, :index]

  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: { errors: user.errors.full_messages}, status: :unprocessable_entry
    end
  end

  def destroy
    begin
      session[:user_id] = nil
      user = User.find(params[:id])
      user.destroy
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render :json => {}, :status => :not_found
    end
  end

  def update
    begin
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user
      else
        render json: { errors: user.errors.full_messages}, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render :json => {}, :status => :not_found
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize_user
    begin
      user = User.find(params[:id])
      unless user == current_user
        render json: "No permission!\n", status: 401
      end
    rescue ActiveRecord::RecordNotFound
      render :json => {}, :status => :not_found
    end
  end
end
