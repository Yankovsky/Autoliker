module Api
  def api(method_name, parameters, access_token)
    api_call_format = 'https://api.vk.com/method/%{method_name}?%{parameters}&access_token=%{access_token}'
    url = URI.parse(api_call_format % {
        method_name: method_name,
        parameters: parameters.map { |k, v| "#{k}=#{v}" }.join('&'),
        access_token: access_token
    })
    https url
  end

  def https(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
    http.get(uri.request_uri).body
  end
end