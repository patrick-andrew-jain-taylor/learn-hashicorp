# Start vagrant
vagrant up
# Start consul server
vagrant ssh n1
consul agent \
  -server \
  -bootstrap-expect=1 \
  -node=agent-one \
  -bind=172.20.20.10 \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d
# Start consul client
vagrant ssh n2
consul agent \
  -node=agent-two \
  -bind=172.20.20.11 \
  -enable-script-checks=true \
  -data-dir=/tmp/consul \
  -config-dir=/etc/consul.d
# Check membership
consul members
# Join agents
consul join 172.20.20.10
# Query node
dig @127.0.0.1 -p 8600 agent-two.node.consul
# Clean up
vagrant destroy
