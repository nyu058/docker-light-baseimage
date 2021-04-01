#!/bin/bash -e


# download curl and ca-certificate from apt-get if needed
to_install=()

if [ "$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    to_install+=("curl")
fi

if [ "$(dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    to_install+=("ca-certificates")
fi

if [ ${#to_install[@]} -ne 0 ]; then
    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${to_install[@]}"
fi

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssl jq

echo "Download cfssl ..."
echo "curl -o /usr/sbin/cfssl -SL https://raw.githubusercontent.com/nyu058/docker-light-baseimage/ppc64le/assets/cfssl"
curl -o /usr/sbin/cfssl -SL "https://raw.githubusercontent.com/nyu058/docker-light-baseimage/ppc64le/assets/cfssl"
chmod 700 /usr/sbin/cfssl

echo "Download cfssljson ..."
echo "curl -o /usr/sbin/cfssljson -SL https://raw.githubusercontent.com/nyu058/docker-light-baseimage/ppc64le/assets/cfssljson"
curl -o /usr/sbin/cfssljson -SL "https://raw.githubusercontent.com/nyu058/docker-light-baseimage/ppc64le/assets/cfssljson"
chmod 700 /usr/sbin/cfssljson

echo "Project sources: https://github.com/cloudflare/cfssl"

# remove tools installed to download cfssl
if [ ${#to_install[@]} -ne 0 ]; then
    apt-get remove -y --purge --auto-remove "${to_install[@]}"
fi
