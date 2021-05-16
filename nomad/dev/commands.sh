# Vagrant Dev environment
vagrant up
# Test nomad
vagrant ssh
nomad
# Start nomad agent
sudo nomad agent -dev -bind 0.0.0.0 -log-level INFO
# Check status
nomad node status
# View members
nomad server members
# Detailed
nomad server members -detailed
# Generate job file
nomad job init
cat example.nomad
# Generate again without comments & stanzas
rm example.nomad
nomad job init -short
cat example.nomad
# Run job
nomad job run example.nomad
# Inspect job
nomad job status example
# Check allocations
nomad alloc status <allocation_id>
# Fetch logs
nomad alloc logs <allocation_id> redis
# Plan updated changes
nomad job plan example.nomad
# Run change
nomad job run -check-index <index> example.nomad
# Check allocations
nomad job status example
# Stop job
nomad job stop example
# Check allocations
nomad job status example
# Halt vagrant
vagrant halt
# Destroy VM
vagrant destroy
