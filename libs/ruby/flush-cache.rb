
require 'dalli'
require_relative 'base-runner'

class FlushCache
  include BaseRunner

  def run

    log "Running FlushCache"

    raise "Can't flush cache TARGET_APP_NAME is not defined" unless ENV.has_key?("TARGET_APP_NAME")

    target_app_name = ENV["TARGET_APP_NAME"]

    memcachier_servers = %x(heroku config:get MEMCACHIER_SERVERS -a #{target_app_name}).chop
    memcachier_username = %x(heroku config:get MEMCACHIER_USERNAME -a #{target_app_name}).chop
    memcachier_password = %x(heroku config:get MEMCACHIER_PASSWORD -a #{target_app_name}).chop

    if all_present?(memcachier_servers, memcachier_username ,memcachier_password)
      log "Flushing cache on #{memcachier_servers.split(",")}"
      cache = Dalli::Client.new(memcachier_servers.split(","),
      {:username => memcachier_username,
       :password => memcachier_password,
       :failover => true,
       :socket_timeout => 1.5,
       :socket_failure_delay => 0.2
      })

      cache.flush

    end
  end

  def all_present?(*strings)
    strings.map{|v| !v.nil? and !v.empty?}.reduce{|a,b| a and b}
  end

end
