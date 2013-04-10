# encoding: utf-8
require 'net/http'
require 'json'
require_relative 'vk'

@interval = 0.25 # https://vk.com/pages?oid=-2226515&p=FAQ 5 сообщений в секунду
@app_id = 3555739 # Autoliker

VK = Vk.new

def authorize
  # all
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/dev/permissions
  permissions = %w(wall offline).join(',')
  authorize_uri = URI.parse("https://oauth.vk.com/authorize?client_id=#{@app_id}&redirect_uri=https://oauth.vk.com/blank.html&scope=#{permissions}&display=page&response_type=token")
  puts authorize_uri
  Net::HTTP.get(authorize_uri)
end

def like_all_wall_posts(owner_id, access_token)
  wall_posts_per_request = 30
  wall_get_response = JSON.parse(VK.wall.get(owner_id, wall_posts_per_request))['response']
  total_wall_posts_size = wall_get_response[0]
  puts 'total posts %s' % total_wall_posts_size
  wall_posts = wall_get_response[1..-1]
  puts 'obtained wall posts size %s' % wall_posts.size

  #0.upto total_wall_posts_size % wall_posts_per_request

  wall_posts.collect { |x| x['id'] }.each_with_index do |post_id, i|
    puts 'current post %s' % i
    #fuck_captcha_hard_each_n_posts(i, access_token)
    result = VK.wall.add_like(owner_id, post_id, access_token)
    p result
    fuck_captcha_if_needed(result, owner_id, post_id, access_token)
    sleep @interval
  end
end

def fuck_captcha_hard_each_n_posts(i, access_token)
  if i % 5 == 4
    puts 'each forth post we fuck captcha hard'
    fuck_captcha_hard access_token
  end
end

def fuck_captcha_hard(access_token)
  5.times do |i|
    p i
    dislike_result = VK.wall.delete_like(12468007, 257, access_token)
    p dislike_result
    sleep @interval
  end
end

def fuck_captcha_if_needed(result, owner_id, post_id, access_token)
  error = JSON.parse(result)['error']
  if !error.nil? && error['error_code'] == 14
    # 14 for 'captcha needed' error
    puts 'got captcha needed error; try to fuck captcha'
    fuck_captcha_hard access_token
    result = VK.wall.add_like(owner_id, post_id, access_token)
    puts 'try to like post again and got %s' % result
  end
end

def like_dislike_same_post(access_token)
  100.times do |i|
    p i
    like_result = VK.wall.add_like(12468007, 257, access_token)
    p like_result
    dislike_result = VK.wall.delete_like(12468007, 257, access_token)
    p dislike_result
    sleep @interval
  end
end


# 8kIT2zSVuNb1Kg3v99WA some token

# yankovsky id 137565
# pavlova id 60338161
# coder pavel id 12468007

users = {
  yankovsky: 137565,
  pavel: 12468007,
  pavlova: 60338161
}

tokens = {
  pavel: '45cc0899efd6586ad5a4e8631e0fcae059fb76ff6bc98789613272b5ce72ec540526f8bfd93e34001524d',
  andrey: 'e0f1eb6e9b7a9b034df9a74d62ab1ef962f442ca3ec671d832838f73640d6019ae26734e49c8fd58cb532'
}

#authorize

#like_all_wall_posts 12468007, 'e0f1eb6e9b7a9b034df9a74d62ab1ef962f442ca3ec671d832838f73640d6019ae26734e49c8fd58cb532'
like_all_wall_posts 43014898, tokens[:pavel]

#api('wall.addLike', {owner_id: 12468007, post_id: 246, captcha_sid: 750546661016, captcha_key: 'qaav'},'45cc0899efd6586ad5a4e8631e0fcae059fb76ff6bc98789613272b5ce72ec540526f8bfd93e34001524d')