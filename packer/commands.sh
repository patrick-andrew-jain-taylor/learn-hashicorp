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
# Build with var files
packer build --var-file=example.pkrvars.hcl docker-ubuntu.pkr.hcl
# Build with auto vars
packer build .
# Set var from command line
packer build --var docker_image=ubuntu:groovy .
# Verify tags
docker images learn-packer
