require './const'
require './game_object'
require 'gosu'

# Player class.
class Player < GameObject
  attr_reader :x, :y, :score

  def initialize(map, x, y)
    super()

    @x = x
    @y = y
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = map
    @beep = Gosu::Sample.new('media/beep.wav')
    # Load all animation frames
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles('media/player.png', 50, 50)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing
    @score = 0
  end

  def draw
    super

    # Flip vertically when facing to the left.
    if @dir == :left
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, Const::ZOrder::PLAYER, factor, 1.0)
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
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

    # Select image depending on action
    @cur_image = if move_x == 0
                   @standing
                 else
                   (Gosu.milliseconds / 175).even? ? @walk1 : @walk2
                 end
    @cur_image = @jump if @vy < 0

    # Directional walking, horizontal movement
    if move_x > 0
      @dir = :right
      move_x.times { @x += 1 if would_fit(1, 0) }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { @x -= 1 if would_fit(-1, 0) }
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1
    # Vertical movement
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
    # Same as in the tutorial game.
    gems.reject! do |c|
      res = ((c.x - @x).abs < 50) && ((c.y - @y).abs < 50)
      if res
        @score += 10
        @beep.play(0.3)
        c.parent.remove_object(c)
      end

      res
    end
  end

  def collide_enemies(enemies)
    enemies.reject! do |e|
      res = ((e.x - @x).abs < 50) && ((e.y - @y).abs < 50)

      if res
        @score -= 20 if @score >= 20
        @beep.play(0.3)
        e.parent.remove_object(e)
      end

      res
    end
  end
end
