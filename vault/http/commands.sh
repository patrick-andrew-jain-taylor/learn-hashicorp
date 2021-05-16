# Create config
tee config.hcl <<EOF
storage "file" {
  path = "vault-data"
}

listener "tcp" {
  tls_disable = "true"
}
EOF
# Start server
vault server -config=config.hcl
# Initalize vault with API
curl \
    --request POST \
    --data '{"secret_shares": 1, "secret_threshold": 1}' \
    http://127.0.0.1:8200/v1/sys/init | jq
# Export & Unseal
export VAULT_TOKEN="<token>"
curl \
    --request POST \
    --data '{"key": "<key>"}' \
    http://127.0.0.1:8200/v1/sys/unseal | jq
# Validate init status
curl http://127.0.0.1:8200/v1/sys/init
# See cURL equivalent for AppRole enable - vault auth enable <auth_method_type>
vault auth enable -output-curl-string approle
# Enable AppRole auth method
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{"type": "approle"}' \
    http://127.0.0.1:8200/v1/sys/auth/approle
# Create AppRole with ACL policies
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request PUT \
    --data '{"policy":"# Dev servers have version 2 of KV secrets engine mounted by default, so will\n# need these paths to grant permissions:\npath \"secret/data/*\" {\n  capabilities = [\"create\", \"update\"]\n}\n\npath \"secret/data/foo\" {\n  capabilities = [\"read\"]\n}\n"}' \
    http://127.0.0.1:8200/v1/sys/policies/acl/my-policy
# Enable KV v2 Secrets Engine
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{ "type":"kv-v2" }' \
    http://127.0.0.1:8200/v1/sys/mounts/secret
# Specify tokens for AppRole my-role associate with my-policy
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{"policies": ["my-policy"]}' \
    http://127.0.0.1:8200/v1/auth/approle/role/my-role
# Fetch RoleID of role named my-role
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
     http://127.0.0.1:8200/v1/auth/approle/role/my-role/role-id | jq -r ".data"
# Create new SecretID under my-role
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    http://127.0.0.1:8200/v1/auth/approle/role/my-role/secret-id | jq -r ".data"
# Fetch new Vault token
curl --request POST \
       --data '{"role_id": "<role_id>", "secret_id": "<secret_id"}' \
       http://127.0.0.1:8200/v1/auth/approle/login | jq -r ".auth"
# Export returned token
export VAULT_TOKEN="<token>"
# Create v1 secret named creds with key password and value set to my-long-password
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request POST \
    --data '{ "data": {"password": "my-long-password"} }' \
    http://127.0.0.1:8200/v1/secret/data/creds | jq -r ".data"
# Stop server and unset vault token
ps aux | grep "vault server" | grep -v grep | awk '{print $2}' | xargs kill
unset VAULT_TOKEN
