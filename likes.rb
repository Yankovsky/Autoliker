require_relative 'api'

class Likes
  include Api

  def add(owner_id, post_id, access_token)
    api('likes.add', {owner_id: owner_id, item_id: post_id, type: 'post'}, access_token)
  end
end