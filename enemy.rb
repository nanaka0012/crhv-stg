require './game_object'
require 'gosu'

class Enemy < GameObject
  attr_reader :x, :y

  def initialize(map, x, y)
    super()

    @x = x
    @y = y
    @dir = :right
    @map = map
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles('media/moving_enemy.png', 50, 50)
    @cur_image = @standing
    @move_x = 4
    @vy = 0
    @count = 0
  end

  def draw
    super

    if @dir == :left
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, Const::ZOrder::PLAYER, factor, 1.0)
  end

  def would_fit(offs_x, offs_y)
    !@map.solid?(@x + offs_x - 20, @y + offs_y) and
      !@map.solid?(@x + offs_x + 20, @y + offs_y - 45) and
      !@map.solid?(@x + offs_x + 20, @y + offs_y) and
      !@map.solid?(@x + offs_x - 20, @y + offs_y - 45)
  end

  def update
    super

    @count += 1

    @move_x *= -1 if @count % 120 == 0

    @cur_image = if @move_x == 0
                   @standing
                 else
                   (Gosu.milliseconds / 175).even? ? @walk1 : @walk2
                 end
    @cur_image = @jump if @vy < 0

    if @move_x > 0
      @dir = :right
      @move_x.times { @x += 1 if would_fit(1, 0) }
    end
    if @move_x < 0
      @dir = :left
      (-@move_x).times { @x -= 1 if would_fit(-1, 0) }
    end

    @vy += 1
    if @vy > 0
      @vy.times { would_fit(0, 1) ? (@y += 1) : (@vy = 0) }
    end
    if @vy < 0
      (-@vy).times { would_fit(0, -1) ? (@y -= 1) : (@vy = 0) }
    end
  end
end
