require './game_object'
require './map'

class GameScene < GameObject
  def initialize
    super

    @sky = Gosu::Image.new('media/space.png', tileable: true)

    @map = Map.new('media/map.txt')
    add_object(@map)

    @player = Player.new(@map, 400, 100)
    add_object(@player)

    @ui = UI.new(20)
    # The scrolling position is stored as top left corner of the screen.
    @camera_x = @camera_y = 0
  end

  def draw
    @sky.draw(0, 0, Const::ZOrder::BACKGROUND)
    @ui.draw(@player.score)
    Gosu.translate(-@camera_x, -@camera_y) do
      super
    end
  end

  def update
    # Scrolling follows player
    @camera_x = [[@player.x - Const::Window::WIDTH / 2, 0].max, @map.width * 50 - Const::Window::WIDTH].min
    @camera_y = [[@player.y - Const::Window::HEIGHT / 2, 0].max, @map.height * 50 - Const::Window::HEIGHT].min

    @player.collect_gems(@map.gems)
    @player.collide_enemies(@map.enemies)

    super
  end
end
