#!/usr/bin/env ruby

require 'dalli'

raise "Can't flush cache TARGET_APP_NAME is not defined" unless ENV.has_key?("TARGET_APP_NAME")

target_app_name = ENV["TARGET_APP_NAME"]

MEMCACHIER_SERVERS = %x(heroku config:get MEMCACHIER_SERVERS -a #{target_app_name}).chop
MEMCACHIER_USERNAME = %x(heroku config:get MEMCACHIER_USERNAME -a #{target_app_name}).chop
MEMCACHIER_PASSWORD = %x(heroku config:get MEMCACHIER_PASSWORD -a #{target_app_name}).chop

if !MEMCACHIER_SERVERS && !MEMCACHIER_SERVERS.empty? && !MEMCACHIER_USERNAME && !MEMCACHIER_USERNAME.empty? && !MEMCACHIER_PASSWORD && !MEMCACHIER_PASSWORD.empty? 
    
  cache = Dalli::Client.new(MEMCACHIER_SERVERS.split(","),
  {:username => MEMCACHIER_USERNAME,
   :password => MEMCACHIER_PASSWORD,
   :failover => true,
   :socket_timeout => 1.5,
   :socket_failure_delay => 0.2
  })

  cache.flush

end
