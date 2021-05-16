# Create server config file
tee config.hcl <<EOF
ui = true
disable_mlock = true

storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"
EOF
# Create data path
mkdir -p vault/data
# Run server
vault server -config=config.hcl
# Stop vault and remove data
ps aux | grep "vault server" | grep -v grep | awk '{print $2}' | xargs kill
unset VAULT_TOKEN
rm -r vault
