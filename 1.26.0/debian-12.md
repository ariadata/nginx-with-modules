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

deb_files=(
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-ndk_1.26.0+0.3.3-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-brotli_1.26.0+1.0.0-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-echo_1.26.0+1.0-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-fips-check_1.26.0+0.1-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-geoip2_1.26.0+3.4-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-headers-more_1.26.0+0.35-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-lua_1.26.0+0.10.26-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-njs_1.26.0+0.8.4-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-passenger_1.26.0+6.0.19-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-perl_1.26.0-1~bookworm_amd64.deb"
  "https://github.com/ariadata/nginx-with-modules/raw/main/1.26.0/debian-12/nginx-module-subs-filter_1.26.0+0.6.4-1~bookworm_amd64.deb"
)
mkdir -p deb-files
for url in "${deb_files[@]}"; do
  filename=$(basename "$url")
  curl -fsSL -o "deb-files/$filename" "$url"
done

apt install --no-install-suggests --no-install-recommends -yq ./deb-files/*.deb

rm -rf ./deb-files/


### Download GeoIP2 Files:
mkdir -p /etc/geoip2/
wget -O /etc/geoip2/GeoLite2-ASN.mmdb $(curl -s https://api.github.com/repos/PrxyHunter/GeoLite2/releases/latest |grep browser_ |grep GeoLite2-ASN.mmdb |cut -d\" -f4)
wget -O /etc/geoip2/GeoLite2-City.mmdb $(curl -s https://api.github.com/repos/PrxyHunter/GeoLite2/releases/latest |grep browser_ |grep GeoLite2-City.mmdb |cut -d\" -f4)
wget -O /etc/geoip2/GeoLite2-Country.mmdb $(curl -s https://api.github.com/repos/PrxyHunter/GeoLite2/releases/latest |grep browser_ |grep GeoLite2-Country.mmdb |cut -d\" -f4)


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

