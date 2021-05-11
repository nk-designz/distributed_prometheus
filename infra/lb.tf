resource "digitalocean_loadbalancer" "public" {
  name   = "m3db-lb"
  region = "fra1"

  forwarding_rule {
    entry_port      = 7201
    entry_protocol  = "http"
    target_port     = 7201
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port      = 8500
    entry_protocol  = "http"
    target_port     = 8500
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port      = 9090
    entry_protocol  = "http"
    target_port     = 9090
    target_protocol = "http"
  }

  healthcheck {
    port     = 7201
    protocol = "tcp"
  }

  droplet_ids = [
      for id in digitalocean_droplet.m3db-nodes.*.id:
      id
  ]
}