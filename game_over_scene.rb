require './game_object'
require './const'

class GameOverScene < GameObject
  def initialize
    super()

    @background = Gosu::Image.new('media/space.png', tileable: true)

    @title = Gosu::Font.new(76, { name: 'media/vera.ttf' })
    @ui = Gosu::Font.new(38, { name: 'media/vera.ttf' })

    @character = Gosu::Image.load_tiles('media/player.png', 50, 50)[1]
  end

  def draw
    super
    @background.draw(0, 0, Const::ZOrder::BACKGROUND)

    title_text = 'GAME OVER'
    title_position = (Const::Window::WIDTH / 2) - (@title.text_width(title_text) / 2)

    ui_text = 'Press SPACE to ReStart'
    ui_position = (Const::Window::WIDTH / 2) - (@ui.text_width(ui_text) / 2)

    @title.draw_text(title_text, title_position, 120, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @ui.draw_text(ui_text, ui_position, 350, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

    @character.draw_rot(Const::Window::WIDTH / 2, 280, Const::ZOrder::UI, 95)
  end

  def update
    super
    $main.scene = GameScene.new if Gosu.button_down? Gosu::KB_SPACE
  end
end
