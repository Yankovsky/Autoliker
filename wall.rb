require_relative 'api'

class Wall
  include Api

  def get(owner_id, count = 100, offset = 0, filter = 'owner')
    api('wall.get', {owner_id: owner_id, count: count, offset: offset, filter: filter}, nil)
  end

  def delete_all_likes(access_token)
  end

  def delete_like(owner_id, post_id, access_token)
    api('wall.deleteLike', {owner_id: owner_id, post_id: post_id}, access_token)
  end

  def add_like(owner_id, post_id, access_token)
    api('wall.addLike', {owner_id: owner_id, post_id: post_id}, access_token)
  end
end