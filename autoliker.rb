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

#puts api('isAppUser', {uid: 137565, }, '8f995ab305668323926ca1904cbe0ec3832e335f243fc3554cf5b3a311ba95c28a85f669051b3f9a23d87')

def get_rights
  puts Net::HTTP.get(URI.parse('https://oauth.vk.com/authorize?client_id=3555739&redirect_uri=https://oauth.vk.com/blank.html&scope=offline,wall&display=page&response_type=token'))
end

# yankovsky id 137565
# pavlova id 60338161
def like_last_10_wall_posts
  wall_posts_per_request = 100
  messages = ['Бложе мой', 'Волшебный чай.', 'Класс!']
  likes_add_result = []
  wall_posts = JSON.parse(api('wall.get', {count: wall_posts_per_request, offset: 0, owner_id: 60338161, filter: 'owner'}, nil))['response']
  p wall_posts_size = wall_posts[0]
  loop do
    wall_posts_size
    wall_posts[1..-1].collect { |x| x['id'] }.each do |post_id|
      result = api('wall.addLike', {owner_id: 60338161, post_id: post_id}, '8f995ab305668323926ca1904cbe0ec3832e335f243fc3554cf5b3a311ba95c28a85f669051b3f9a23d87', true)
      p result
      sleep 0.201
    end
  end

# Autoliker
# 3555739
# 8kIT2zSVuNb1Kg3v99WA
end


like_last_10_wall_posts()