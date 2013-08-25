require 'time'
require 'mongo-db-utils/version'
require 'mongo-db-utils/tools/commands'
require 'mongo-db-utils/models/db'
require 'fileutils'

# Some shared utilities used in the deployment scripts
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

  def in_dir(path, &block)
    return_dir = Dir.pwd
    ch_dir path
    if block_given?
      block.call
    end
    ch_dir return_dir
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

  def env_var(key, required = true)
    if ENV[key].nil? and required
      raise "#{key} not specified"
    else
      ENV[key]
    end
  end

end
