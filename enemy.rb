class Enemy
  attr_reader :x, :y

  def initialize(map, x, y)
    @x, @y = x, y
    @dir = :right
    @map = map
    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles("media/moving_enemy.png", 50, 50)
    @cur_image = @standing
    @move_x = 4
    @vy = 0 # Vertical velocity
    @count = 0
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
  
  def update()
    @count += 1

    # Select image depending on action
    if @count % 120 == 0
      @move_x *= -1
    end

    if (@move_x == 0)
      @cur_image = @standing
    else
      @cur_image = (Gosu.milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end
    if (@vy < 0)
      @cur_image = @jump
    end
    
    # Directional walking, horizontal movement
    if @move_x > 0
      @dir = :right
      @move_x.times { if would_fit(1, 0) then @x += 1 end }
    end
    if @move_x < 0
      @dir = :left
      (-@move_x).times { if would_fit(-1, 0) then @x -= 1 end }
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
  
  # def try_to_jump
  #   if @map.solid?(@x - 20, @y + 1) or @map.solid?(@x + 20, @y + 1)
  #     @vy = -20
  #   end
  # end


end