require 'gosu'
require './const'
require './player'

class GameUI < GameObject
  attr_reader :font

  def initialize(player)
    super()

    @player = player

    @score_ui = Gosu::Font.new(20)
    @life_ui = Gosu::Image.load_tiles('media/player.png', 50, 50)[0]
  end

  def draw
    super

    @score_ui.draw_text("Score: #{@player.score}", 10, 10, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @player.life.times do |i|
      @life_ui.draw(Const::Window::WIDTH - 30 - 20 * i, 10, Const::ZOrder::UI, 0.5, 0.5)
    end
  end
end
