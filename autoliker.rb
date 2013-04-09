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
  sleep 0.2
end

# https://vk.com/pages?oid=-2226515&p=FAQ 5 сообщений в секунду


def authorize
  # all
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/pages?oid=-1&p=%D0%9F%D1%80%D0%B0%D0%B2%D0%B0_%D0%BF%D1%80%D0%B8%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B9
  # http://vk.com/dev/permissions

  app_id = 3555739
  permissions = %w(wall offline).join(',')
  puts Net::HTTP.get(URI.parse("https://oauth.vk.com/authorize?client_id=#{app_id}&redirect_uri=https://oauth.vk.com/blank.html&scope=#{permissions}&display=page&response_type=token"))
end

def like_all_wall_posts
  wall_posts_per_request = 100
  messages = ['Бложе мой', 'Волшебный чай.', 'Класс!']
  likes_add_result = []
  wall_posts = JSON.parse(api('wall.get', {count: wall_posts_per_request, offset: 0, owner_id: 60338161, filter: 'owner'}, nil))['response']
  p wall_posts_size = wall_posts[0]
  loop do
    wall_posts_size
    wall_posts[1..-1].collect { |x| x['id'] }.each do |post_id|
      result = api('wall.addLike', {owner_id: 60338161, post_id: post_id}, '8f995ab305668323926ca1904cbe0ec3832e335f243fc3554cf5b3a311ba95c28a85f669051b3f9a23d87')
      p result
      sleep 0.201
    end
  end

# Autoliker
# 3555739
# 8kIT2zSVuNb1Kg3v99WA
end


like_last_10_wall_posts()


# yankovsky id 137565
# pavlova id 60338161