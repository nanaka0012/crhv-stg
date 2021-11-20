require './const'
require './collectible_gem'
require './enemy'
require './game_object'

class Map < GameObject
  attr_reader :width, :height, :gems, :enemies

  def initialize(filename)
    super()

    @tileset = Gosu::Image.load_tiles('media/tileset.png', 60, 60, tileable: true)

    @gems = []
    @enemies = []

    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
        when '"'
          Const::Tiles::GRASS
        when '#'
          Const::Tiles::EARTH
        when 'x'
          gem = CollectibleGem.new(x * 50 + 25, y * 50 + 25)
          @gems.push(gem)
          add_object(gem)
          nil
        when 'e'
          enemy = Enemy.new(self, x * 50 + 25, y * 50 + 25)
          @enemies.push(enemy)
          add_object(enemy)
          nil
        end
      end
    end
  end

  def draw
    super

    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        next unless tile

        @tileset[tile].draw(x * 50 - 5, y * 50 - 5, Const::ZOrder::TILES)
      end
    end
  end

  def solid?(x, y)
    y < 0 || @tiles[x / 50][y / 50]
  end
end
