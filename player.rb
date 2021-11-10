require './const.rb'

# Player class.
class Player
  attr_reader :x, :y, :score

  def initialize(map, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = 0 # Vertical velocity
    @map = map
    @beep = Gosu::Sample.new("media/beep.wav")
    # Load all animation frames
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles("media/player.png", 50, 50)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing
    @score = 0  
  end
  
  def draw
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
    not @map.solid?(@x + offs_x - 20, @y + offs_y) and
      not @map.solid?(@x + offs_x + 20, @y + offs_y - 45) and
      not @map.solid?(@x + offs_x + 20, @y + offs_y) and
      not @map.solid?(@x + offs_x- 20, @y + offs_y - 45)
  end
  
  def update(move_x)
    # Select image depending on action
    if (move_x == 0)
      @cur_image = @standing
    else
      @cur_image = (Gosu.milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end
    if (@vy < 0)
      @cur_image = @jump
    end
    
    # Directional walking, horizontal movement
    if move_x > 0
      @dir = :right
      move_x.times { if would_fit(1, 0) then @x += 1 end }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { if would_fit(-1, 0) then @x -= 1 end }
    end

    # Acceleration/gravity
    # By adding 1 each frame, and (ideally) adding vy to y, the player's
    # jumping curve will be the parabole we want it to be.
    @vy += 1
    # Vertical movement
    if @vy > 0
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end
  
  def try_to_jump
    if @map.solid?(@x - 20, @y + 1) or @map.solid?(@x + 20, @y + 1)
      @vy = -20
    end
  end
  
  def collect_gems(gems)
    # Same as in the tutorial game.
    gems.reject! do |c|
      if (c.x - @x).abs < 50 and (c.y - @y).abs < 50
        @score += 10
        @beep.play(0.3)
      end
    end
  end

  def collide_enemies(enemies)
    enemies.reject! do |e|
      if (e.x - @x).abs < 50 and (e.y - @y).abs < 50
        @score -= 20 if @score >= 20
        @beep.play(0.3)
      end
    end
  end
end