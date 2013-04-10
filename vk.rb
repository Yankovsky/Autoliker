require_relative 'wall'
require_relative 'likes'

class Vk
  attr_reader :wall, :likes

  def initialize
    @wall = Wall.new
    @likes = Likes.new
  end
end