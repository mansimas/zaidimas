uri = URI.parse(ENV["REDISTOGO_URL"] || 'redis://127.0.0.1')
REDIS = Redis.new(:host => uri.host, :port => uri.port || 6379, :password => uri.password, :driver => :hiredis)
