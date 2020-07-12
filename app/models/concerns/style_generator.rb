class StyleGenerator
  TEXT_COLORS = ['blue', 'red', 'yellow', 'orange', 'brown', '#5F4B8BFF', '#00203FFF', '#EEA47FFF', '#9CC3D5FF', '#FEE715FF', '#E94B3CFF', '#990011FF', '#FCF6F5FF', 'white', 'yellow', 'black', 'black', 'yellow', '#E69A8DFF', '#ADEFD1FF', '#00539CFF', '#0063B2FF', '#101820FF', '#2D2926FF', '#FCF6F5FF', '#990011FF']
  BG_COLORS   = ['white', 'yellow', 'black', 'black', 'yellow', '#E69A8DFF', '#ADEFD1FF', '#00539CFF', '#0063B2FF', '#101820FF', '#2D2926FF', '#FCF6F5FF', '#990011FF', 'blue', 'red', 'yellow', 'orange', 'brown', '#5F4B8BFF', '#00203FFF', '#EEA47FFF', '#9CC3D5FF', '#FEE715FF', '#E94B3CFF', '#990011FF', '#FCF6F5FF']

  def initialize(post)
    @post = post
  end

  def set_to_default
    @post.style = nil
    @post.save
  end

  def generate
    i = (0..(TEXT_COLORS.length - 1)).to_a.sample
    @post.style = {
      text_color: TEXT_COLORS[i],
      background_color: BG_COLORS[i]
    }
    @post.save
  end
end