# Run in dev mode
consul agent -dev -node machine
# See clients
consul members
# Additional detail
consul members -detailed
# Strong consistency
curl localhost:8500/v1/catalog/nodes
# DNS interface
dig @127.0.0.1 -p 8600 machine.node.consul
# Stop cluster
consul leave
# Consul configuration directory
mkdir consul.d
# Write service definition file
echo '{
  "service": {
    "name": "web",
    "tags": [
      "rails"
    ],
    "port": 80
  }
}' > ./consul.d/web.json
# Restart agent with config directory
consul agent -dev -enable-script-checks -config-dir=./consul.d
# Query using DNS
dig @127.0.0.1 -p 8600 web.service.consul
# Query using DNS - full name (SRV)
dig @127.0.0.1 -p 8600 web.service.consul SRV
# Filter services by tags
dig @127.0.0.1 -p 8600 rails.web.service.consul
# Query using HTTP API
curl http://localhost:8500/v1/catalog/service/web
# Query for healthy instances
curl 'http://localhost:8500/v1/health/service/web?passing'
# Update service definition file
echo '{
  "service": {
    "name": "web",
    "tags": [
      "rails"
    ],
    "port": 80,
    "check": {
      "args": [
        "curl",
        "localhost"
      ],
      "interval": "10s"
    }
  }
}' > ./consul.d/web.json
# Reload consul
consul reload
# Store data
consul agent -dev
# Add min
consul kv put redis/config/minconns 1
# Add max
consul kv put redis/config/maxconns 25
# Add metadata
consul kv put -flags=42 redis/config/users/admin abcd1234
# Query value
consul kv get redis/config/minconns
# Retrieve detailed metadata
consul kv get -detailed redis/config/users/admin
# List all keys in KV store
consul kv get -recurse
# Delete data
consul kv delete redis/config/minconns
# Delete all redis keys
consul kv delete -recurse redis
# Update existing key
consul kv put foo bar
# Get updated key
consul kv get foo
# Put new value at path
consul kv put foo zip
# Check updated path
consul kv get foo
# UI
consul agent -dev -ui
