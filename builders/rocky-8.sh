docker run -v ./rocky-8-nginx:/compiled_modules/ -it rockylinux:8 bash

dnf update -y
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf -y install aria2 bind-utils chrony fcgi git htop httpd-tools iotop iperf3 lsof net-tools nmap numactl poppler-utils sysstat traceroute unzip wget yum-utils zip ps_mem libcurl-devel libxml2-devel patchelf pkgconfig perl-Parse-RecDescent libmaxminddb-devel mercurial brotli-devel rpm-build krb5-devel openssl-devel pcre2-devel pcre-devel
dnf -y group install "Development Tools"
dnf -y --enablerepo=powertools install doxygen yajl-devel

hg clone -r 1.24.0-1 https://hg.nginx.org/pkg-oss/ && cd pkg-oss/rpm/SPECS && make list-all-modules

make module-auth-spnego
make module-lua
make module-geoip2
make module-subs-filter
make module-rtmp
make module-set-misc
make module-fips-check
make module-ndk
make module-brotli
make module-encrypted-session
make module-headers-more

cp -R /pkg-oss/rpm/RPMS/x86_64/* /compiled_modules
