class Api::ListsController < ApiController
  before_action :require_login!
  before_action :authorize_user, except: [:index, :create]

  def index
    lists = List.all
    render json: lists, each_serializer: ListSerializer
  end

  def create
    #current user should be the one that creates the list not the url's user
    list = current_user.lists.build(list_params)

    if list.save
      render json: list
    else
      render json: { errors: list.errors.full_messages}, status: :unprocessable_entry
    end
  end

  def destroy
    begin
      list = List.find(params[:id])
      list.destroy
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end

  def update
    begin
      list = List.find(params[:id])
      if list.update(list_params)
        render json: list
      else
        render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end

  private
  def list_params
    params.require(:list).permit(:title, :private)
  end

  def authorize_user
    begin
      list = List.find(params[:id])
      user = User.find(params[:user_id])
      unless current_user == list.user && current_user == user
        render json: "No permission!\n", status: 401
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end
end
