# Initalize
packer init .
# FMT
packer fmt .
# Validate
packer validate .
# Build
packer build docker-ubuntu.pkr.hcl
# Verify Docker build
docker images
# Destroy image
docker rmi <image_id>
