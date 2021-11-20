require './effect'
require './const'

class SmokeEffect < Effect
  def initialize
    super

    @image = Gosu::Image.new('media/smoke.png')
    @count = 0
  end

  def draw
    super
    x_offset = @image.width * (0.1 + 0.1 * @count) / 2
    y_offset = @image.height * (0.1 + 0.2 * @count) / 2
    @image.draw(@x - x_offset, @y - y_offset, Const::ZOrder::EFFECT, 0.1 + 0.1 * @count, 0.1 + 0.1 * @count,
                0xff_ffffff, :add)
  end

  def update
    super
    @count += 1
    parent.remove_object(self) if @count == 10
  end
end
