storage "file" {
  path = "vault-data"
}

listener "tcp" {
  tls_disable = "true"
}

# Additional command for my machine
disable_mlock = true
