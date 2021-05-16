# Running vault as dev:
vault server -dev
# Checking vault status:
vault status
# Create secret:
vault kv put secret/hello foo=world excited=yes
# Get secret:
vault kv get secret/hello
# JSON format:
vault kv get -format=json secret/hello | jq -r .data.data.excited
# Delete secret:
vault kv delete secret/hello
# New secrets path:
vault secrets enable -path=kv kv
# List secrets engines:
vault secrets list
# Put secret in secrets engine:
vault kv put kv/hello target=world
# Disable secrets engine:
vault secrets disable kv/
# AWS secrets engine:
vault secrets enable -path=aws aws
# AWS Config (NOT FOR PRODUCTION):
vault write aws/config/root \
> access_key= \
> secret_key= \
> region=us-east-1
# AWS role:
vault write aws/roles/my-role \
credential_type=iam_user \
policy_document=-<<EOF
{
"Version": "2012-10-17",
"Statement": [
{
"Sid": "Stmt1426528957000",
"Effect": "Allow",
"Action": [
"ec2:*"
],
"Resource": [
"*"
]
}
]
}
EOF

# Create role (user) with active creds:
vault read aws/creds/my-role
# Revoke role (user):
vault lease revoke <lease_id>
# Help:
vault path-help aws
# Specific help:
vault path-help aws/creds/my-non-existent-role
# Create new token:
vault token create
# Login with new token:
vault login <token>
# Revoke token:
vault token revoke <token>
# Enable github authentication:
vault auth enable github
# Set organization for github:
vault write auth/github/config organization=NotSwayze
# Allow teams in org access to policies:
vault write auth/github/map/teams/Vault value=default,applications
# Display auth methods:
vault auth list
# Help with auth method:
vault auth help github
# Login using github:
vault login -method=github
# Revoke tokens:
vault token revoke -mode path auth/github
# Disable github auth:
vault auth disable github
# View auth policy:
vault policy read default
# Write policy:
vault policy write -h
# Create policy from stdin:
vault policy write my-policy - << EOF
# Dev servers have version 2 of KV secrets engine mounted by default, so will
# need these paths to grant permissions:
path "secret/data/*" {
capabilities = ["create", "update"]
}

path "secret/data/foo" {
capabilities = ["read"]
}
EOF

# List all policies:
vault policy list
# View contents of policy:
vault policy read my-policy
# Test policy
export VAULT_TOKEN="$(vault token create -field token -policy=my-policy)"
# Validate token
vault token lookup | grep policies
# Write secret to path
vault kv put secret/creds password="my-long-password"
# Attemp write to forbidden path
vault kv put secret/foo robot=beepboop
# Associate policies to auth method
export VAULT_TOKEN=<root_token>
vault auth list | grep 'approle/'
# if blank
vault auth enable approle
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=my-policy
# Validate AppRole is attaching policy by authing
export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)"
export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)"
vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"
# Terminate dev & revoke token
# CTRL-C
unset VAULT_TOKEN
# Deploy Vault - Prod

