require "test_helper"

class MessageTest < ActiveSupport::TestCase
  # Action Cable broadcasts go through Postgres NOTIFY, which rejects payloads
  # over 8000 bytes.
  POSTGRES_NOTIFY_LIMIT = 8000

  def message_with(content)
    Message.new(chatroom: chatrooms(:upcoming), user: users(:bob), content: content)
  end

  test "a message up to the maximum length is valid" do
    assert message_with("a" * Message::MAX_LENGTH).valid?
  end

  test "a message over the maximum length is refused" do
    message = message_with("a" * (Message::MAX_LENGTH + 1))

    assert_not message.valid?
    assert_includes message.errors[:content], "is too long (maximum is #{Message::MAX_LENGTH} characters)"
  end

  # Guards MAX_LENGTH against the real constraint: "&" is the worst case
  # (HTML-escaped to &amp;, then JSON-escaped to &amp;).
  test "the largest possible message still fits in one broadcast" do
    message = message_with("&" * Message::MAX_LENGTH)
    message.id = 1
    message.created_at = Time.current
    html = ApplicationController.render(partial: "messages/message", locals: { message: message })

    channel_payload = { message: html, sender_id: message.user.id }.to_json
    turbo_payload = %(<turbo-stream action="append" target="messages"><template>#{html}</template></turbo-stream>).to_json

    assert_operator channel_payload.bytesize, :<, POSTGRES_NOTIFY_LIMIT
    assert_operator turbo_payload.bytesize, :<, POSTGRES_NOTIFY_LIMIT
  end
end
