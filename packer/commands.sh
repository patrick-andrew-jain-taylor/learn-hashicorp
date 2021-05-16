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
# Launch image
docker run -it <image_id>
# Check for provisioned file
cat example.txt
# Exit
exit
