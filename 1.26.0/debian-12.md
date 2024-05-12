### Prepare Debian-12
```sh
apt update && apt -yq upgrade && apt -yq auto-remove

apt install -yq apt-transport-https aria2 bzip2 ca-certificates chrony cron curl dnsutils ethtool git htop iotop iperf jcal jq lsb-release nano net-tools nmap openssl p7zip poppler-utils rsync software-properties-common traceroute unar unzip wget zip

apt -yq --no-install-recommends install python3-pip

# https://github.com/PrxyHunter/GeoLite2/releases/latest

```


### Install nginx and modules
```sh

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list

apt -yq update && apt -y install nginx=1.26.0-1~bookworm

systemctl enable --now nginx

apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/
apt -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/

```

### Sxample of nginx.conf in `/etc/nginx/nginx.conf`
```nginx
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;

load_module /etc/nginx/modules/ngx_http_geoip2_module.so;
load_module /etc/nginx/modules/ngx_stream_geoip2_module.so;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
}

```
