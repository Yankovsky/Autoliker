# encoding: utf-8
require 'net/http'
require 'json'

def api(method_name, parameters, access_token)
  api_call_format = 'https://api.vk.com/method/%{method_name}?%{parameters}&access_token=%{access_token}'
  url = URI.parse(api_call_format % {
      method_name: method_name,
      parameters: parameters.map { |k, v| "#{k}=#{v}" }.join('&'),
      access_token: access_token
  })
  Net::HTTP.get(url)
end

# https://vk.com/pages?oid=-2226515&p=FAQ 5 сообщений в секунду


def authorize
  # all
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/dev/permissions

  app_id = 3555739
  permissions = %w(wall offline).join(',')
  authorize_uri = URI.parse("https://oauth.vk.com/authorize?client_id=#{app_id}&redirect_uri=https://oauth.vk.com/blank.html&scope=#{permissions}&display=page&response_type=token")
  puts authorize_uri
  Net::HTTP.get(authorize_uri)
end

def like_all_wall_posts(access_token)
  wall_posts_per_request = 100
  wall_posts = JSON.parse(api('wall.get', {count: wall_posts_per_request, offset: 0, owner_id: 12468007, filter: 'owner'}, nil))['response']
  p wall_posts_size = wall_posts[0]

  wall_posts[1..-1].collect { |x| x['id'] }.each do |post_id|
    result = api('wall.addLike', {owner_id: 12468007, post_id: post_id}, access_token)
    if !JSON.parse(result)['error'].nil? && JSON.parse(result)['error']['error_code'] == 14
      fuck_captcha_hard access_token
      result = api('wall.addLike', {owner_id: 12468007, post_id: post_id}, access_token)
    end
    p result
    sleep 0.5
  end

# Autoliker
# 3555739
# 8kIT2zSVuNb1Kg3v99WA
end

def fuck_captcha_hard(access_token)
  5.times do |i|
    p i
    dislike_result = api('wall.deleteLike', {owner_id: 12468007, post_id: 257}, access_token)
    p dislike_result
    sleep 0.5
  end
end

def like_dislike_same_post(access_token)
  100.times do |i|
    p i
    like_result = api('wall.addLike', {owner_id: 12468007, post_id: 257}, access_token)
    p like_result
    dislike_result = api('wall.deleteLike', {owner_id: 12468007, post_id: 257}, access_token)
    p dislike_result
    sleep 1
  end
end

# yankovsky id 137565
# pavlova id 60338161
# coder pavel id 12468007
# pavel 45cc0899efd6586ad5a4e8631e0fcae059fb76ff6bc98789613272b5ce72ec540526f8bfd93e34001524d
# andrey e0f1eb6e9b7a9b034df9a74d62ab1ef962f442ca3ec671d832838f73640d6019ae26734e49c8fd58cb532

#authorize

#like_all_wall_posts 'e0f1eb6e9b7a9b034df9a74d62ab1ef962f442ca3ec671d832838f73640d6019ae26734e49c8fd58cb532'
like_all_wall_posts '45cc0899efd6586ad5a4e8631e0fcae059fb76ff6bc98789613272b5ce72ec540526f8bfd93e34001524d'

#api('wall.addLike', {owner_id: 12468007, post_id: 246, captcha_sid: 750546661016, captcha_key: 'qaav'},'45cc0899efd6586ad5a4e8631e0fcae059fb76ff6bc98789613272b5ce72ec540526f8bfd93e34001524d')