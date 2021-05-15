# Create storage backend
mkdir -p vault/data
# Update config
vault server -config=config.hcl
# Initialize vault
export VAULT_ADDR='http://127.0.0.1:8200'
vault operator init
# Unseal vault - run 3 times
vault operator unseal
# Provide key 1
vault operator unseal
# Provide key 2
vault operator unseal
# Provide key 3
# Auth with root
vault login <Initial_Root_Token>
# Kill vault
ps aux | grep "vault server" | grep -v grep | awk '{print $2}' | xargs kill
# Clear data
rm -r vault/data
