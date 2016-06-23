class MessagesController < ApplicationController
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
    if @message.save
      redirect_to root_path, notice: 'リクエストを保存しました'
    else
      # リクエストが保存できなかった時
      flash.now[:alert] = "リクエストの保存に失敗しました。"
      render 'new'
    end
  end

  def edit
  end
  
  def update
    if @message.update(message_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to root_path, notice: 'メッセージを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def destroy
    @message.destroy
    redirect_to current_user, notice: 'メッセージを削除しました'
  end

  private
  def message_params
    params.require(:message).permit(:user_id, :tipe, :media, :start, :finish, :rink)
  end

  def set_message
    @message = Message.find(params[:id])
  end
  
  def user_params
    params.require(:user)
  end
end
