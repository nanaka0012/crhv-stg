require './game_object'
require './const'

class GameCearScene < GameObject
  def initialize
    super()

    @background = Gosu::Image.new('media/space.png', tileable: true)

    @title = Gosu::Font.new(76, { name: 'media/vera.ttf' })
    @ui = Gosu::Font.new(38, { name: 'media/vera.ttf' })

    @character = Gosu::Image.load_tiles('media/player.png', 50, 50)[3]
    @gem = Gosu::Image.new('media/gem.png')

    @blink = Gosu::Image.load_tiles('media/star.png', 25, 25)[0]
  end

  def draw
    super
    @background.draw(0, 0, Const::ZOrder::BACKGROUND)

    title_text = 'GAME CLEAR !'
    title_position = (Const::Window::WIDTH / 2) - (@title.text_width(title_text) / 2)

    ui_text = 'Press ENTER to Back'
    ui_position = (Const::Window::WIDTH / 2) - (@ui.text_width(ui_text) / 2)

    @title.draw_text(title_text, title_position, 100, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    @ui.draw_text(ui_text, ui_position, 350, Const::ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

    @character.draw(Const::Window::WIDTH / 2 - @character.width / 2, 200, Const::ZOrder::PLAYER)
    @gem.draw_rot(Const::Window::WIDTH / 2 - @gem.width / 2 + 20, 300, Const::ZOrder::GEMS, 45, 0.5, 0.5, 2, 2)

    @blink.draw(Const::Window::WIDTH / 2 + 50, 240, Const::ZOrder::EFFECT, 1, 1, 0xff_ffff00)
    @blink.draw(Const::Window::WIDTH / 2 + 65, 300, Const::ZOrder::EFFECT, 1, 1, 0xff_ffff00)
    @blink.draw(Const::Window::WIDTH / 2 - 70, 240, Const::ZOrder::EFFECT, 1, 1, 0xff_ffff00)
    @blink.draw(Const::Window::WIDTH / 2 - 80, 280, Const::ZOrder::EFFECT, 1, 1, 0xff_ffff00)
  end

  def update
    super
    $main.scene = TitleScene.new if Gosu.button_down? Gosu::KB_RETURN
  end
end
