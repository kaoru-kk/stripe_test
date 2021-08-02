class MessageChannel < ApplicationCable::Channel
  def subscribed
    p 'channel'
    p 'start sub'
    stream_from "message_channel"

    ActionCable.server.broadcast 'message_channel', messages: Message.all, event: 'all_messages'
  end

  def unsubscribed
    p 'this is unsub'     
  end

  def speak(data)
    p 'speak rb'
    p data

    @message = Message.create(
      text: data['message'],
      # ID１が管理者、それ以外をユーザーとする
      user_id: data['user_id'],
    )
    
    ActionCable.server.broadcast 'message_channel', message: @message, event: 'single_message'
  end
end