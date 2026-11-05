class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find_by(id: params[:id])

    # Same rule as ChatroomsController#show: only members may listen.
    if chatroom && Pundit.policy!(current_user, chatroom).show?
      stream_for chatroom
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
