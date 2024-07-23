class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatroom
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to @chatroom }
        format.turbo_stream
      end
    else
      render "chatrooms/show", status: :unprocessable_entity
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:chatroom_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
