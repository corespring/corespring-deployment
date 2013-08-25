require 'time'
require 'mongo-db-utils/version'
require 'mongo-db-utils/tools/commands'
require 'mongo-db-utils/models/db'
require 'fileutils'

# Some shared utilities used in the deployment scripts
#
#
module BaseRunner

  include MongoDbUtils::Tools
  include MongoDbUtils::Model

  def log(msg)
    puts "[#{Time.now.strftime("%I:%M%p")}] #{msg}"
  end

  def on_path(tool)
    run_cmd("which #{tool}"){ |p| raise "missing #{tool} on PATH" }
  end

  def has_folder(path)
    full_path = File.expand_path(path)
    FileUtils.mkdir_p full_path unless File.exist? full_path
  end

  def ch_dir(path)
    Dir.chdir(File.expand_path(path))
  end


  def run_cmd(cmd, &block)

    log "[running: #{cmd}]"

    IO.popen(cmd) do |io|
      while line = io.gets
        puts "#{line}\n" unless line.empty?
      end
      io.close

      if block_given?
        block.call($?) if $?.to_i != 0
      else
        raise "An error occured" if $?.to_i != 0
      end
    end
  end


  def get_migrator_uri(uri, replica_set_name)
    if(uri.include?(","))
      raise "[URI Problem] -- we think this is a replica set uri: #{uri} - if it is we also need the replica set name." if replica_set_name.nil?
      "#{replica_set_name}|#{uri}"
    else
      uri
    end
  end

  def commit_hash
    return_dir = File.expand_path(Dir.pwd)
    app_path = env_var "APP_PATH"
    ch_dir app_path
    hash = `git rev-parse --short HEAD`.strip
    ch_dir return_dir
    hash
  end

  def env_var(key, required = true)
    if ENV[key].nil? and required
      raise "#{key} not specified"
    else
      ENV[key]
    end
  end

  def get_db(uri, replica_set_name)


    if(uri.include?(","))
      raise "[URI Problem] -- we think this is a replica set uri: #{uri} - if it is we also need the replica set name." if replica_set_name.nil?
      ReplicaSetDb.new(uri, replica_set_name)
    else
      Db.new(uri)
    end
  end

end
