class Api::ItemsController < ApiController

  def create
    list = List.find(params[:list_id])
    item = list.items.build(item_params)

    if item.save
      render json: item
    else
      render json: {errors: item.errors.full_messages}, status: :unprocessable_entry
    end
  end

  private
  def item_params
    params.require(:item).permit(:body)
  end
end
