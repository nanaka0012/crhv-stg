# Encoding: UTF-8

# A simple jump-and-run/platformer game with a tile-based map.

# Shows how to
#  * implement jumping/gravity
#  * implement scrolling using Window#translate
#  * implement a simple tile-based map
#  * load levels from primitive text files

# Some exercises, starting at the real basics:
#  0) understand the existing code!
# As shown in the tutorial:
#  1) change it use Gosu's Z-ordering
#  2) add gamepad support
#  3) add a score as in the tutorial game
#  4) similarly, add sound effects for various events
# Exploring this game's code and Gosu:
#  5) make the player wider, so he doesn't fall off edges as easily
#  6) add background music (check if playing in Window#update to implement 
#     looping)
#  7) implement parallax scrolling for the star background!
# Getting tricky:
#  8) optimize Map#draw so only tiles on screen are drawn (needs modulo, a pen
#     and paper to figure out)
#  9) add loading of next level when all gems are collected
# ...Enemies, a more sophisticated object system, weapons, title and credits
# screens...

require 'gosu'
require './player'
require './map'
require './collectible_gem'
require './const'
require './ui'

class Main < (Example rescue Gosu::Window)
  def initialize
    super Const::Window::WIDTH, Const::Window::HEIGHT

    self.caption = "Collect. Ruby"

    @sky = Gosu::Image.new("media/space.png", tileable: true)
    @map = Map.new("media/map.txt")
    @player = Player.new(@map, 400, 100)
    @ui = UI.new(20)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
  end

  def update
    move_x = 0
    move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    @player.update(move_x)
    @player.collect_gems(@map.gems)
    @player.collide_enemies(@map.enemies)
    @map.enemies.each { |e| e.update }

    # Scrolling follows player
    @camera_x = [[@player.x - Const::Window::WIDTH / 2, 0].max, @map.width * 50 - Const::Window::WIDTH].min
    @camera_y = [[@player.y - Const::Window::HEIGHT / 2, 0].max, @map.height * 50 - Const::Window::HEIGHT].min
  end
  
  def draw
    @sky.draw(0, 0, Const::ZOrder::BACKGROUND)
    @ui.draw(@player.score)
    Gosu.translate(-@camera_x, -@camera_y) do
      @map.draw
      @player.draw
    end
  end
  
  def button_down(id)
    case id
    when Gosu::KB_UP
      @player.try_to_jump
    when Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

Main.new.show if __FILE__ == $0
