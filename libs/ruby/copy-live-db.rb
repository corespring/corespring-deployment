require_relative 'base-runner'

require 'mongo-db-utils/version'
require 'mongo-db-utils/tools/commands'
require 'mongo-db-utils/models/db'


class CopyLiveDb
  include BaseRunner

  def run
    live_db_uri = env_var "CORESPRING_LIVE_DB_URI"
    live_db_replica_set = env_var "CORESPRING_LIVE_DB_REPLICA_SET_NAME"
    target_db_uri = env_var "ENV_MONGO_URI"
    target_replica_set_name = env_var "ENV_MONGO_REPLICA_SET_NAME", false
    run_cmd "mkdir -p tmp_folder"
    live_db = get_db( live_db_uri, live_db_replica_set )

    Dump.new(live_db.to_host_s,
      live_db.name,
      "tmp_folder",
      live_db.username,
      live_db.password).run

    target_db = get_db(target_db_uri, target_replica_set_name)

    begin
      puts Restore.new(
        target_db.to_host_s,
        target_db.name,
        "tmp_folder/#{live_db.name}",
        target_db.username,
        target_db.password).run
    rescue ToolsException => mte
      log "MongoToolsException --------->"
      log mte.cmd
      log mte.output
      log "MongoToolsException ---------"
    end
    run_cmd "rm -fr tmp_folder"
  end

  private
  def get_db(uri, replica_set_name)
    if(uri.include?(","))
      raise "[URI Problem] -- we think this is a replica set uri: #{uri} - if it is we also need the replica set name." if replica_set_name.nil?
      ReplicaSetDb.new(uri, replica_set_name)
    else
      Db.new(uri)
    end
  end

end
