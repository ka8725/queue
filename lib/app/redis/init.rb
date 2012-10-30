require 'redis-classy'

#TODO: configure redis to connect with servers specified in config file
Redis::Classy.db = Redis.new(:host => 'localhost')