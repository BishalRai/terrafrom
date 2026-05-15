# Tell Terraform which provider plugin to use
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Hand the provider your API token
provider "digitalocean" {
  token = var.do_token
}

# The actual Droplet (VPS) resource
resource "digitalocean_droplet" "web" {
  name   = "my-first-droplet"
  region = "fra1"          # Frankfurt — close to Finland
  size   = "s-1vcpu-1gb"   # Smallest/cheapest plan (~$6/mo)
  image  = "ubuntu-24-04-x64"

  # SSH key to add to the server (you'll set this up next)
  ssh_keys = [var.ssh_fingerprint]

  # cloud-init: runs as root right after first boot
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y nginx ufw git htop

    # Basic firewall
    ufw allow OpenSSH
    ufw allow 'Nginx HTTP'
    ufw --force enable

    # A simple welcome page
    echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
  EOF
}

# Print the IP once the Droplet is created
output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}
