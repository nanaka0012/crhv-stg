require './const'
require './game_object'

class CollectibleGem < GameObject
  attr_reader :x, :y

  def initialize(x, y)
    super()

    @image = Gosu::Image.new('media/gem.png')
    @x = x
    @y = y
  end

  def draw
    super

    # Draw, slowly rotating
    @image.draw_rot(@x, @y, Const::ZOrder::GEMS, 25 * Math.sin(Gosu.milliseconds / 133.7))
  end
end
