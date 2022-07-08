job "traefik" {
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port "http" {
         static = 80
         host_network = "public"
      }
      port "https" {
         static = 443
         host_network = "public"
      }
      port "admin" {
         static = 8080
         host_network = "wireguard"
      }
    }

    service {
      name = "traefik-http"
      provider = "nomad"
      port = "http"
    }

    volume "letsencrypt" {
      type = "host"
      read_only = false
      source = "letsencrypt"
    }

    task "server" {
      driver = "docker"

      volume_mount {
        volume = "letsencrypt"
        destination = "/letsencrypt"
        read_only = false
      }

      env {
        CLOUDFLARE_EMAIL = "EMAIL"
        CLOUDFLARE_DNS_API_TOKEN = "TOKEN"
      }

      config {
        image = "traefik:2.8"
        ports = ["admin", "http", "https"]
        args = [
          "--api.dashboard=true",
          "--api.insecure=true",
          "--entrypoints.web.address=:${NOMAD_PORT_http}",
          "--entryPoints.websecure.address=:${NOMAD_PORT_https}",
          "--entrypoints.traefik.address=:${NOMAD_PORT_admin}",
          "--providers.nomad=true",
          "--providers.nomad.endpoint.address=http://host.docker.internal:4646",
          "--certificatesresolvers.letsencrypt.acme.dnschallenge=true",
          "--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare",
          "--certificatesresolvers.letsencrypt.acme.email=EMAIL",
          "--certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json",
        ]
        extra_hosts = ["host.docker.internal:host-gateway"]
      }
    }
  }
}