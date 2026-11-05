class ChatroomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chatrooms = policy_scope(Chatroom)
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    authorize @chatroom
    @message = Message.new
    @current_user = current_user
    @other_user = @chatroom.users.where.not(id: current_user.id).first
  end
end
