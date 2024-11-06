<p align="center" style="text-align:center;">
  <a href="assets/nomad.svg">
    <img alt="HashiCorp Nomad logo" src="assets/nomad.svg" width="600" />
  </a>
</p>

# Nomad with Wireguard + Docker
This installation assumes you have a clean Debian installation.

## 🔼 Update system
```bash
apt update
apt upgrade
apt dist-upgrade
apt install vim
reboot
```

## 🔥 Install ufw
```bash
apt install ufw
ufw allow OpenSSH
ufw enable
systemctl start ufw
```

## 🔒 Install Wireguard
```bash
curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
chmod +x wireguard-install.sh
./wireguard-install.sh
```
After script:
```bash
ufw allow in on wg0
ufw allow {WIREGUARD_PORT}/udp
```

## 🍱 Install Nomad
```bash
apt install wget gpg coreutils
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install nomad
```
Edit the file `/etc/nomad.d/nomad.hcl` and replace it with [this](./nomad.hcl) content.

## 🐳 Install Docker
```bash
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
ufw allow in on docker0
```

## 🤖 Create a Nomad systemd service
```bash
touch /etc/systemd/system/nomad.service
```
Edit the file `/etc/systemd/system/nomad.service` and insert [this](./nomad.service) content.
```bash
systemctl enable nomad.service
systemctl start nomad.service
```

Done! A sample task which contains traefik can be found [here](./traefik.hcl).
