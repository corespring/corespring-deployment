require_relative "base-runner"

class CopyS3Assets
  include BaseRunner

  def run
    on_path "s3cmd"
    on_path "cs-api-assets"
    has_folder "~/cs-api-assets"
    target_bucket = env_var "ENV_AMAZON_ASSETS_BUCKET"
    live_bucket = env_var "CORESPRING_LIVE_ASSETS_BUCKET"
    in_dir("~/cs-api-assets") {
      run_cmd "cs-api-assets pull-bucket #{live_bucket}"
      run_cmd "cs-api-assets push-bucket #{live_bucket} --remote-bucket=#{target_bucket}"
    }
  end
end
