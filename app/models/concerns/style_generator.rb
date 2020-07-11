class StyleGenerator
  TEXT_COLORS = ['blue', 'red', 'yellow', 'orange', 'brown']
  BG_COLORS   = ['white', 'yellow', 'black', 'black', 'yellow']

  def initialize(post)
    @post = post
  end

  def set_to_default
    @post.style = nil
    @post.save
  end

  def generate
    i = (0..5).to_a.sample
    @post.style = {
      text_color: TEXT_COLORS[i],
      background_color: BG_COLORS[i]
    }
    @post.save
  end
end