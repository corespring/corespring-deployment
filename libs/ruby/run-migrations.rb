require_relative 'base-runner'

class RunMigrations
  include BaseRunner

  def run(commit_hash)
    # See: github.com/corespring/mongo-migrator for more information
    jar = jar_file( env_var("LIBS_FOLDER") )
    log "jar file: #{jar}"
    migrations_path = env_var "MIGRATIONS_PATH"

    # Note - the current scripts stored in the migrator have a relative path for the script name
    # If we try and migrate from another dir - the sript name will become a full path
    # which means that the migrator will try to re-run old migrations and fail.
    # For now - copy the migrations over so that the relative path remains intact.
    # We'll probably want to 1. reset the versions collection, 2. change the naming so that the root path is removed.
    run_cmd "mkdir -p deployment"
    run_cmd "cp -r #{migrations_path} deployment"
    mongo_uri = env_var "ENV_MONGO_URI"
    replica_set_name = env_var "ENV_MONGO_REPLICA_SET_NAME", false
    uri = get_migrator_uri(mongo_uri, replica_set_name)

    begin
      run_cmd "java -jar #{jar} migrate #{commit_hash} \"#{uri}\" deployment/migrations"
      run_cmd "rm -fr deployment"
    rescue
      log "An error occured"
    end
  end

  private
  def jar_file(libs_folder)
    puts Dir.pwd
    puts "libs folder : #{libs_folder}"
    puts Dir[ File.join(Dir.pwd, libs_folder)].entries
    all = Dir["#{Dir.pwd}/#{libs_folder}/mongo-migrator*.jar"]
    puts all
    all[-1]
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