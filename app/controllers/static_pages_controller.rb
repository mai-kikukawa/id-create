class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @messages = Message.all
    end
  end
end
