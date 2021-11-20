require 'gosu'
require './const'
require './player'

class GameUI < GameObject
  attr_reader :font

  def initialize(player)
    super()

    @player = player

    @score_ui = Gosu::Font.new(32)
    @life_ui = Gosu::Image.load_tiles('media/player.png', 50, 50)[0]
  end

  def draw
    super

    @score_ui.draw_text("Score: #{@player.score}", 10, 10, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @player.life.times do |i|
      @life_ui.draw(Const::Window::WIDTH - 35 - 30 * i, 10, Const::ZOrder::UI, 0.6, 0.6)
    end
  end
end
