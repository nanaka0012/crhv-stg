module Const
  module Window
    WIDTH = 640
    HEIGHT = 480
  end

  module Tiles
    GRASS = 0
    EARTH = 1
  end

  module ZOrder
    BACKGROUND, TILES, GEMS, PLAYER, EFFECT, UI = *0..5
  end
end
