require_relative 'base-runner'

class RunMigrations
  include BaseRunner

  def run(commit_hash)
    # See: github.com/corespring/mongo-migrator for more information
    jar = jar_file( env_var("LIBS_FOLDER") )
    log "jar file: #{jar}"
    migrations_path = env_var "MIGRATIONS_PATH"
    mongo_uri = env_var "ENV_MONGO_URI"
    replica_set_name = env_var "ENV_MONGO_REPLICA_SET_NAME", false
    uri = get_migrator_uri(mongo_uri, replica_set_name)

    begin
      run_cmd "java -jar #{jar} migrate #{commit_hash} \"#{uri}\" #{migrations_path}"
    rescue
      log "An error occured"
    end
  end

  private
  def jar_file(libs_folder)
    Dir["#{libs_folder}/*mongo-migrator*.jar"][-1]
  end

  def get_migrator_uri(uri, replica_set_name)
    if(uri.include?(","))
      raise "[URI Problem] -- we think this is a replica set uri: #{uri} - if it is we also need the replica set name." if replica_set_name.nil?
      "#{replica_set_name}|#{uri}"
    else
      uri
    end
  end

end