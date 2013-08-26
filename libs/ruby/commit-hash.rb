require_relative 'base-runner'

module CommitHash

  include BaseRunner

  def self.get(path_key, branch)
    path = env_var path_key
    hash = ""
    in_dir(path){
      with_branch(branch){
        run_cmd "git fetch origin"
        hash = `git rev-parse --short HEAD`
      }
    }
    hash
  end

  private

  def self.with_branch(branch, &blk)
    result = `git checkout #{branch} 2>&1`
    if result.include? "error:"
      run_cmd "git checkout -b #{branch} origin/#{branch}"
    end
    blk.call
  end
end
