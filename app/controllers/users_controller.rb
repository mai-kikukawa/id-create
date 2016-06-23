class UsersController < ApplicationController
  #before_action :logged_in_user, expect[:new, :create]

  def index
    @users = User.all
  end
  
  def show 
    @user = User.find(params[:id])
    @messages = Message.where(user_id: "#{@user.id}")

  end
  
  def created 
    @user = User.find(params[:id])
    @messages = Message.where(user_id: "#{@user.id}")
    respond_to do |format|
      format.html
      format.csv { send_data @messages.to_csv }
      format.xls { send_data @messages.to_csv(col_sep: "\t") }
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "アカウントを作成しました。"
      redirect_to login_path
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "アカウントを作成しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end