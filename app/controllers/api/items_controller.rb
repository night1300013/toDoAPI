class Api::ItemsController < ApiController
  before_action :require_login!
  before_action :authorize_user, except: [:index]

  def index
    items = Item.all
    render json: items, each_serializer: ItemSerializer
  end

  def create
    begin
      list = List.find(params[:list_id])
      item = list.items.build(item_params)

      if item.save
        render json: item
      else
        render json: {errors: item.errors.full_messages}, status: :unprocessable_entry
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end

  def destroy
    begin
      item = Item.find(params[:id])
      item.destroy
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end

  def update
    begin
      item = Item.find(params[:id])
      if item.update(item_params)
        render json: item
      else
        render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end

  private
  def item_params
    params.require(:item).permit(:body, :completed)
  end

  def authorize_user
    begin
      list = List.find(params[:list_id])
      unless current_user == list.user
        render json: "No permission!\n", status: 401
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end
  end
end
