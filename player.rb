require './const'
require './game_object'
require './shine_effect'
require './smoke_effect'
require 'gosu'

class Player < GameObject
  attr_reader :x, :y, :score, :life

  def initialize(map, x, y)
    super()

    @x = x
    @y = y
    @dir = :left
    @vy = 0
    @map = map
    @collect_sound = Gosu::Sample.new('media/beep.wav')
    @collide_sound = Gosu::Sample.new('media/explosion.wav')
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles('media/player.png', 50, 50)
    @cur_image = @standing
    @score = 0
    @life = 3
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

    move_x = 0
    move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    try_to_jump if Gosu.button_down? Gosu::KB_SPACE

    @cur_image = if move_x == 0
                   @standing
                 else
                   (Gosu.milliseconds / 175).even? ? @walk1 : @walk2
                 end
    @cur_image = @jump if @vy < 0

    if move_x > 0
      @dir = :right
      move_x.times { @x += 1 if would_fit(1, 0) }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { @x -= 1 if would_fit(-1, 0) }
    end

    @vy += 1
    if @vy > 0
      @vy.times { would_fit(0, 1) ? (@y += 1) : (@vy = 0) }
    end
    if @vy < 0
      (-@vy).times { would_fit(0, -1) ? (@y -= 1) : (@vy = 0) }
    end
  end

  def try_to_jump
    @vy = -20 if @map.solid?(@x - 20, @y + 1) || @map.solid?(@x + 20, @y + 1)
  end

  def collect_gems(gems)
    gems.reject! do |c|
      res = ((c.x - @x).abs < 50) && ((c.y - @y).abs < 50)
      if res
        @score += 10
        @collect_sound.play(0.1, 4)
        add_object(ShineEffect.new)
        c.parent.remove_object(c)
      end

      res
    end
  end

  def collide_enemies(enemies)
    enemies.reject! do |e|
      res = ((e.x - @x).abs < 50) && ((e.y - @y).abs < 50)

      if res
        @life -= 1
        @collide_sound.play(0.1, 4)
        add_object(SmokeEffect.new)
        e.parent.remove_object(e)
      end

      res
    end
  end
end
