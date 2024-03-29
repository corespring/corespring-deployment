require_relative "base-runner"

class BackupDb
  include BaseRunner

  def run
    on_path "mongo-db-utils"
    mongo_uri = env_var "ENV_MONGO_URI"
    replica_set_name = env_var "ENV_MONGO_REPLICA_SET_NAME", false
    bucket_name = env_var "CORESPRING_AMAZON_BUCKET"
    access_key = env_var "CORESPRING_AMAZON_ACCESS_KEY"
    secret_key = env_var "CORESPRING_AMAZON_SECRET_KEY"
    cmd = "mongo-db-utils backup_s3 #{mongo_uri} #{bucket_name} #{access_key} #{secret_key}"
    cmd << " #{replica_set_name}" unless replica_set_name.nil?
    run_cmd cmd
  end
end
