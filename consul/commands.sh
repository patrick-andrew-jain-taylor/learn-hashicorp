# Consul Connect
consul agent -dev -enable-script-checks -config-dir=./consul.d -node=machine
# Start basic service
socat -v tcp-l:8181,fork exec:"/bin/cat"
# Verify service
nc 127.0.0.1 8181
# Write new service definition
echo '{
  "service": {
    "name": "socat",
    "port": 8181,
    "connect": {
      "sidecar_service": {}
    }
  }
}' > ./consul.d/socat.json
# Run sidecar
consul connect proxy -sidecar-for socat
# Connect to service
consul connect proxy -service web -upstream socat:9191
# Connect to proxy
nc 127.0.0.1 9191
