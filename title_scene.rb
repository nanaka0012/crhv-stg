require './game_object'
require './const'

class TitleScene < GameObject
  def initialize
    super()

    @background = Gosu::Image.new('media/space.png', tileable: true)

    @title = Gosu::Font.new(76, { name: 'media/vera.ttf' })
    @ui = Gosu::Font.new(38, { name: 'media/vera.ttf' })

    @standing, @walk1, @walk2, @jump = *Gosu::Image.load_tiles('media/player.png', 50, 50)
    @character = @walk1
    @gem = Gosu::Image.new('media/gem.png')
  end

  def draw
    super
    @background.draw(0, 0, Const::ZOrder::BACKGROUND)

    title_text = 'Collect. Ruby'
    title_position = (Const::Window::WIDTH / 2) - (@title.text_width(title_text) / 2)

    ui_text = 'Press SPACE to Start'
    ui_position = (Const::Window::WIDTH / 2) - (@ui.text_width(ui_text) / 2)

    @title.draw_text(title_text, title_position, 120, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @ui.draw_text(ui_text, ui_position, 350, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

    @character.draw(Const::Window::WIDTH / 2 + 60, 245, Const::ZOrder::PLAYER)
    @gem.draw_rot(Const::Window::WIDTH / 2 - 60, 270, Const::ZOrder::GEMS, 25 * Math.sin(Gosu.milliseconds / 133.7))
  end

  def update
    super
    @character = (Gosu.milliseconds / 175).even? ? @walk1 : @walk2
    $main.scene = GameScene.new if Gosu.button_down? Gosu::KB_SPACE
  end
end
