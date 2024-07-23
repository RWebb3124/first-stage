class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chatrooms = current_user.chatrooms
  end

  def show
  @chatroom = Chatroom.find(params[:id])
  @message = Message.new
  @current_user = current_user
  end

  def new
    @chatroom = Chatroom.new
  end

  def create
    @chatroom = current_user.chatrooms.build(chatroom_params)
    if @chatroom.save
      redirect_to @chatroom
    else
      render :new
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:name)
  end
end
