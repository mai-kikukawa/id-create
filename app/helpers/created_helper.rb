module CreatedHelper

  def set_url(message)
    url_extention(message)

    media_id = message.id.to_s
    set_url = message.rink + "?" + @extention + media_id
    set_url
  end

  def publish_id(message)
    url_extention(message)
    
    media_id = message.id.to_s
    publish_id = @extention + media_id
    publish_id
  end
  
  def url_extention(message)
    if message.media == 'yahoo'
      @extention = "yho_"
    elsif message.media == 'google'
      @extention = "gle_"
    elsif message.media == '楽天'
      @extention = "rku_"
    elsif message.media == 'Amazon'
      @extention = "ama_"
    end
  end

end