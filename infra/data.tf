data "digitalocean_ssh_key" "terraform" {
  name = "default"
}

# Generate inventory file
resource "local_file" "inventory" {
 filename = "../inventory/hosts.ini"
 content = <<EOF
[nodes]
%{ for ip in digitalocean_droplet.m3db-nodes.*.ipv4_address }
${ ip }
%{ endfor }
EOF
}