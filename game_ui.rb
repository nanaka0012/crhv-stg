require 'gosu'
require './const'
require './player'

class GameUI < GameObject
  attr_reader :font

  def initialize(height, player)
    super()

    @player = player

    @font = Gosu::Font.new(height)
  end

  def draw
    super

    @font.draw_text("Score: #{@player.score}", 10, 10, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end
end
