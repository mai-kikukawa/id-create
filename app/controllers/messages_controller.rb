class MessagesController < ApplicationController
  include CreatedHelper
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all
  end
  
  def show
  end
  
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    if @message.save
      @message.createdurl = set_url(@message)
      @message.createdid = publish_id(@message)
      @message.update(message_params)
      redirect_to current_user, notice: 'リクエストを保存しました'
    else
      render 'new'
    end
  end

  def edit
  end
  
  def update
    @message.update(message_params)
    if @message.update(message_params)
      @message.createdurl = set_url(@message)
      @message.createdid = publish_id(@message)
      @message.update(message_params)
      redirect_to current_user, notice: 'リクエストを編集しました'
    else
      render 'edit'
    end
  end
  
  def destroy
    @message.destroy
    redirect_to current_user, notice: 'リクエストを削除しました'
  end

  private
  def message_params
    params.require(:message).permit(:user_id, :tipe, :media, :start, :finish, :rink, :createdurl, :createdid)
  end

  def set_message
    @message = Message.find(params[:id])
  end
  
  # def user_params
  #   params.require(:user)
  # end
end
