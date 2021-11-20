require './game_object'

class Effect < GameObject
  def initialize
    super()
  end

  def update
    super

    @x = parent.x if parent.respond_to?(:x)
    @y = parent.y if parent.respond_to?(:y)
  end
end
