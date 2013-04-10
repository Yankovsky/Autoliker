module Api
  def api(method_name, parameters, access_token)
    api_call_format = 'https://api.vk.com/method/%{method_name}?%{parameters}&access_token=%{access_token}'
    url = URI.parse(api_call_format % {
        method_name: method_name,
        parameters: parameters.map { |k, v| "#{k}=#{v}" }.join('&'),
        access_token: access_token
    })
    Net::HTTP.get(url)
  end
end