require './game_object'
require './map'
require './game_ui'
require './game_over_scene'
require './game_clear_scene'

class GameScene < GameObject
  def initialize
    super

    @background = Gosu::Image.new('media/space.png', tileable: true)

    @map = Map.new('media/map.txt')
    add_object(@map)

    @player = Player.new(@map, 400, 100)
    add_object(@player)

    @ui = GameUI.new(@player)

    @camera_x = @camera_y = 0
  end

  def draw
    @background.draw(0, 0, Const::ZOrder::BACKGROUND)
    @ui.draw
    Gosu.translate(-@camera_x, -@camera_y) do
      super
    end
  end

  def update
    @camera_x = [[@player.x - Const::Window::WIDTH / 2, 0].max, @map.width * 50 - Const::Window::WIDTH].min
    @camera_y = [[@player.y - Const::Window::HEIGHT / 2, 0].max, @map.height * 50 - Const::Window::HEIGHT].min

    @player.collect_gems(@map.gems)
    @player.collide_enemies(@map.enemies)

    $main.scene = GameOverScene.new if @player.life == 0
    $main.scene = GameCearScene.new if @map.gems.length == 0
    super
  end
end
