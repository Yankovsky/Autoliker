require "thread"

m = Mutex.new
c = ConditionVariable.new
t = []

t << Thread.new do
  m.synchronize do
    puts "A - I am in critical region"
    c.wait(m)
    puts "A - Back in critical region"
  end
end

t << Thread.new do
  m.synchronize do
    puts "A - I am in critical region"
    c.wait(m)
    puts "A - Back in critical region"
  end
end

t << Thread.new do
  m.synchronize do
    puts "B - I am critical region now"
    c.broadcast
    puts "B - I am done with critical region"
  end
end

t.each {|th| th.join }