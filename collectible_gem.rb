require './const.rb'

class CollectibleGem
  attr_reader :x, :y

  def initialize(x, y)
    @image = Gosu::Image.new("media/gem.png")
    @x, @y = x, y
  end
  
  def draw
    # Draw, slowly rotating
    @image.draw_rot(@x, @y, Const::ZOrder::GEMS, 25 * Math.sin(Gosu.milliseconds / 133.7))
  end
end