require 'gosu'
require './const.rb'
require './player'

class UI
  attr_reader :font

  def initialize(height)
    @font = Gosu::Font.new(height)
  end

  def draw(score)
    @font.draw("Score: #{score}", 10, 10, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end
end
