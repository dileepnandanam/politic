class StyleGenerator
  TEXT_COLORS = ['black', 'white', 'yellow', 'black', 'black', '#fcfbe2', '#c7c6bc', '#e9c8ec', '#a9aff8', '#ffed1f', '#fffac6', 'white', '#f7e205']
  BG_COLORS   = ['white', 'black', 'black', '#bdbdb8', '#fbfbe7', 'black', 'black', 'black', 'black', '#1c2550', '#7b0c54', '#480d0d', '#480d0d']

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