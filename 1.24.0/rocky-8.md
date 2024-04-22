### Prepare RockyLinux 8
```sh
dnf -y update
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf -y install aria2 bind-utils chrony fcgi git nano htop httpd-tools iotop iperf3 lsof net-tools nmap numactl poppler-utils sysstat traceroute unzip wget yum-utils zip ps_mem
dnf -y autoremove

cp /etc/selinux/config /etc/selinux/config.bk
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# timedatectl set-timezone Asia/Tehran
systemctl disable --now rpcbind rpcbind.socket

systemctl disable --now firewalld
```


### Install nginx and modules
```sh
curl https://raw.githubusercontent.com/ariadata/nginx-with-modules/main/repo/rhel.repo -o /etc/yum.repos.d/nginx.repo

#yum-config-manager --enable nginx-mainline
#yum-config-manager --enable nginx-mainline
# dnf info nginx-1.24.0

dnf -y install nginx-1.24.0

dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-auth-spnego-1.24.0+1.1.0-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-ndk-1.24.0+0.3.2-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-brotli-1.24.0+1.0.0-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-encrypted-session-1.24.0+0.09-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-fips-check-1.24.0+0.1-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-geoip2-1.24.0+3.4-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-headers-more-1.24.0+0.34-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-lua-1.24.0+0.10.22-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-rtmp-1.24.0+1.2.2-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-set-misc-1.24.0+0.33-1.el8.ngx.x86_64.rpm
dnf -y install https://github.com/ariadata/nginx-with-modules/raw/main/1.24.0/rocky-8/nginx-module-subs-filter-1.24.0+0.6.4-1.el8.ngx.x86_64.rpm

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

