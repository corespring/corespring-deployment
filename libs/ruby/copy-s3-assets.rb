require_relative "base-runner"

class CopyS3Assets
  include BaseRunner

  def run
    on_path "aws"
    target_bucket = env_var "ENV_AMAZON_ASSETS_BUCKET"
    live_bucket = env_var "CORESPRING_LIVE_ASSETS_BUCKET"
    run_cmd "aws s3 sync --delete #{live_bucket} #{target_bucket}"
  end
end
