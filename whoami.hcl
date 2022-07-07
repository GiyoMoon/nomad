job "whoami" {
  datacenters = ["dc1"]

  type = "service"

  group "demo" {
    count = 1

    network {
       port "http" {
         to = 80
         host_network = "public"
       }
    }

    service {
      name = "whoami-demo"
      port = "http"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=Host(`whoami.example.com`)",
        "traefik.http.routers.http.tls.certresolver=letsencrypt",
      ]
    }

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }
    }
  }
}