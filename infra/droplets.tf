resource "digitalocean_droplet" "m3db-nodes" {
    count = 3
    image = "centos-8-x64"
    name = "m3db-node-${count.index}"
    region = "fra1"
    size = "s-4vcpu-8gb-amd"
    private_networking = true
    ssh_keys = [
      data.digitalocean_ssh_key.terraform.id
    ]
    connection {
      host = self.ipv4_address
      user = "root"
      type = "ssh"
      private_key = file(var.pvt_key)
      timeout = "2m"
    }
    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install updates
        "dnf update -y",
        "dnf install python3 -y"
      ]
    }
}