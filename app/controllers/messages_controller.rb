class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    @message = Message.new(text: params[:message][:text])
    if @message.save
      ActionCable.server.broadcast 'message_channel', content: @message

      p 'controller'
    end
  end
end
