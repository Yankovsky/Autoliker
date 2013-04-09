@threads = []

@last_api_call_time = Time.new

def spawn
  @threads << Thread.new {
    sleep 0.2
    api
  }
end


def api
  Thread.new {

  }
  new_time = Time.new
  puts 'api', (new_time - @last_api_call_time)
  @last_api_call_time = new_time
  spawn
end

api

@threads.each &:join