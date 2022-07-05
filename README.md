<p align="center" style="text-align:center;">
  <a href="assets/nomad.svg">
    <img alt="HashiCorp Nomad logo" src="assets/nomad.svg" width="600" />
  </a>
</p>

# Nomad with Wireguard + Docker
This installation assumes you have a clean Debian installation.

## 🔼 Update system
```bash
apt-get update
apt-get dist-upgrade
apt-get install vim
```

## 🔥 Install ufw
```bash
sudo apt install ufw
sudo ufw allow OpenSSH
sudo ufw enable
```

## 🔒 Install Wireguard
```bash
curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
chmod +x wireguard-install.sh
./wireguard-install.sh
```
After script:
```bash
sudo ufw allow in on wg0
sudo ufw allow {WIREGUARD_PORT}/udp
```

## 🍱 Install Nomad
```bash
sudo apt-get install -y gnupg2 software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install nomad
```
Edit the file `/etc/nomad.d/nomad.hcl` and replace it with [this](./nomad.hcl) content.

## 🐳 Install Docker
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo ufw allow in on docker0
```

## 🤖 Create a Nomad systemd service
```bash
sudo touch /etc/systemd/system/nomad.service
```
Edit the file `/etc/systemd/system/nomad.service` and insert [this](./nomad.service) content.
```bash
sudo usermod -G docker -a nomad
sudo systemctl enable nomad.service
sudo systemctl start nomad.service
```

Done! A sample task which contains traefik can be found [here](./traefik.hcl).