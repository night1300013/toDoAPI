class Api::ListsController < ApiController

  def create
    #current user should be the one that creates the list not the url's user
    list = current_user.lists.build(list_params)
    #list.user_id = params[:user_id]

    if list.save
      render json: list
    else
      render json: { errors: list.errors.full_messages}, status: :unprocessable_entry
    end
  end

  private
  def list_params
    params.require(:list).permit(:title, :private)
  end
end
