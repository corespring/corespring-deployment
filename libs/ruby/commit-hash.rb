require_relative 'base-runner'

class CommitHash
  include BaseRunner
  def get(path_key, branch)

    path = env_var path_key
    hash = ""
    puts Dir.pwd
    in_dir(path){
      with_branch(branch){
        run_cmd "git fetch origin"
        hash = `git rev-parse --short HEAD`.strip
      }
    }
    puts Dir.pwd
    hash
  end

  private

  def with_branch(branch, &blk)
    result = `git checkout #{branch} 2>&1`
    if result.include? "error:"
      run_cmd "git checkout -b #{branch} origin/#{branch}"
    end
    blk.call
  end

end
