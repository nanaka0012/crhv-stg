require 'gosu'
require './const'
require './game_scene'
require './title_scene'

class Main < Gosu::Window
  attr_writer :scene

  def initialize
    super Const::Window::WIDTH, Const::Window::HEIGHT

    self.caption = 'Collect. Ruby'

    @scene = TitleScene.new
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

$main = Main.new

$main.show if __FILE__ == $0
