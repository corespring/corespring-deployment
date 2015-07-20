require_relative 'base-runner'

class SeedStaticData 
  include BaseRunner

  def run(path_key, branch)

    puts "seed static data"

    path = env_var path_key
    puts Dir.pwd
    in_dir(path){
      cmd = "play -Dallow.remote.seeding=true \"seed-prod\""
      run_cmd cmd
    }
  end
end
