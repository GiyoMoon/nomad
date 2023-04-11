# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

server {
  # license_path is required as of Nomad v1.1.1+
  #license_path = "/opt/nomad/nomad.hclic"
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  host_network "public" {
    interface = "eth0"
  }
  host_network "wireguard" {
    interface = "wg0"
  }
}

# If you want to use docker auth credentials from the root user
plugin "docker" {
  config {
    auth {
      config = "/root/.docker/config.json"
    }
  }
}
