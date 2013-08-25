# Corespring Deployment

Deployment scripts to be run by the [deploy-tool](https://github.com/corespring/deploy-cli).

# Running

Before you run you'll need to configure the environments files, these aren't in git because they contain sensitive information.

    cp your_env_folder corespring-deployment/env
    cd corespring-deployment
    deploy-tool push before corespring-app-qa

# System requirements

* [deploy-tool](https://github.com/corespring/deploy-cli)
* [mongo-db-utils](https://github.com/edeustace/mongo-db-utils)
* [cs-api-assets](https://github.com/corespring/corespring-api-assets)
* [s3cmd-modification](https://github.com/corespring/s3cmd-modification)
