class Api::ListsController < ApiController
  before_action :require_login!

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

  private
  def list_params
    params.require(:list).permit(:title, :private)
  end
end
