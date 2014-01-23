# Corespring Deployment

Deployment scripts to be run by the [deploy-tool](https://github.com/corespring/deploy-cli).

The deploy tool needs 2 things:
* the env folder path (default: current_dir/env)
* the scripts folder path (default: current_dir/scripts)

It'll then run the scripts in this folder with the env vars set from the env folder.

# Running

Before you run you'll need to configure the environments files, these aren't in git because they contain sensitive information.

    cp your_env_folder corespring-deployment/env
    cd corespring-deployment
    deploy-tool push before corespring-app-qa




This will set the env vars in `env/common/*.properties` and `env/corespring-app-qa/*.properties`, then run the scripts in this order: `scripts/common/push/before/*` then `scripts/corespring-app-qa/push/before/*`.

You'll finally want to set the following env vars:


## Heroku Env vars

Note that these env vars are to allow you to run the scripts - they aren't env vars for your heroku instance.

### TODO: How do we update heroku env vars?


* APP_PATH - the path to the corespring-api source
* MIGRATIONS_PATH - the path to the migrations folder in the corepsring-api source
* ENV_AMAZON_ASSETS_BUCKET - the amazon bucket to deploy s3 assets to

# System requirements

* [deploy-tool](https://github.com/corespring/deploy-cli)
* [mongo-db-utils](https://github.com/edeustace/mongo-db-utils)
* [cs-api-assets](https://github.com/corespring/corespring-api-assets)
* [s3cmd-modification](https://github.com/corespring/s3cmd-modification)
