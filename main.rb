require 'gosu'
require './player'
require './map'
require './collectible_gem'
require './const'
require './ui'
require './game_scene'

class Main < Gosu::Window
  def initialize
    super Const::Window::WIDTH, Const::Window::HEIGHT

    self.caption = 'Collect. Ruby'

    @scene = GameScene.new
  end

  def update
    @scene&.update
  end

  def draw
    @scene&.draw
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Main.new.show if __FILE__ == $0
