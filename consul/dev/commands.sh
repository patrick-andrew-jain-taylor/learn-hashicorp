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
