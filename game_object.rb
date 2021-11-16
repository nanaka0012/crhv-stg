class GameObject
  attr_reader :parent, :objects

  def initialize
    @objects = []
    @parent = nil
  end

  def draw
    @objects.each do |object|
      object.draw
    end
  end

  def update
    @objects.each do |object|
      object.update
    end
  end

  def add_object(object)
    unless object.is_a?(GameObject)
      puts 'error add_object: not GameObject'
      return
    end

    object.parent = self
    @objects << object
  end

  def remove_object(object)
    return unless @objects.include?(object)

    object.parent = nil
    @objects.delete(object)
  end

  protected

  attr_writer :parent
end
