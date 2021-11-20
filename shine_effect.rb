require './effect'

class ShineEffect < Effect
  def initialize
    super

    @image = Gosu::Image.load_tiles('media/star.png', 25, 25)[0]
    @count = 0
  end

  def draw
    super
    @image.draw(@x - ((@count / 5).even? ? 25 : - 20), @y - ((@count / 5).even? ? 20 : 40),
                Const::ZOrder::EFFECT, 0.5, 0.5, 0xff_ffff00)
  end

  def update
    super
    @count += 1
    parent.remove_object(self) if @count == 20
  end
end
