require_relative 'base-runner'

require 'tmpdir'
require 'mongo-db-utils/cmd'
require 'mongo-db-utils/s3'
require 'mongo-db-utils/version'
require 'mongo-db-utils/tools/commands'
require 'mongo-db-utils/models/db'



class RestoreDbFromS3
  include BaseRunner
  include MongoDbUtils

  def run
    live_db_name = 'corespring-production'
    
    target_db_uri = env_var 'ENV_MONGO_URI'
    target_replica_set_name = env_var 'ENV_MONGO_REPLICA_SET_NAME', false
    target_db = get_db(target_db_uri, target_replica_set_name)
    
    bucket_name = env_var 'CORESPRING_AMAZON_PROD_BACKUPS_BUCKET'
    access_key_id = env_var 'CORESPRING_AMAZON_ACCESS_KEY'
    secret_access_key = env_var 'CORESPRING_AMAZON_SECRET_KEY'

    Dir.mktmpdir do |tmp_dir|
      backup = Cmd.download_backup_from_s3(tmp_dir, 'latest', bucket_name, access_key_id, secret_access_key)
      Cmd.restore_from_backup(tmp_dir, target_db, File.basename(backup), live_db_name )
    end    
  end

  private
  def get_db(uri, replica_set_name)
    if(uri.include?(','))
      raise "[URI Problem] -- we think this is a replica set uri: #{uri} - if it is we also need the replica set name." if replica_set_name.nil?
      ReplicaSetDb.new(uri, replica_set_name)
    else
      Db.new(uri)
    end
  end

end
