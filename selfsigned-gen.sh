#!/bin/bash

if ! command -v openssl &>/dev/null; then
	echo "Openssl is not installed"
	exit 1
fi

san_number=1
nrsans=0
thishost=$(hostname)
hostip=$(hostname -i)
domain=$(hostname -d)
fqdn=$(hostname -f)
locale_country=$(localectl status | grep LC_NAME | awk '{print substr($1,12,2)}')

read -p "Enter key filename [key.pem]: " keyfile
keyfile=${keyfile:-key.pem}
read -p "Enter certificate filename [cert.pem]: " certfile
certfile=${certfile:-cert.pem}
read -p "Enter country [$locale_country]: " country
country=${country:-$locale_country}
read -p "Enter State [NONE]: " state
state=${state:-NONE}
read -p "Enter Location: " loc
read -p "Enter Company or Organization name: " company
read -p "Enter Unit or Department [TEST]: " department
department=${department:-TEST}
read -p "Enter contact email: " email
read -p "Enter hostname/ip: [$thishost] " hostinfo
hostinfo=${hostinfo:-$thishost}


while true; do
    read -p "Do you wish to add another IP/hostname aka (SAN)? (y/n): " yn
    case $yn in
        [Yy]*)
            read -p "Enter additional hostname/ip : " san
            sans+=("$san")
            ((nrsans++))
            ;;
        [Nn]*)
            break
            ;;

        *)
            echo "Invalid response"
            ;;
    esac
done

echo "[CA_default]" > ./.sslconf
echo "copy_extensions = copy" >> ./.sslconf
echo "[req]" >> ./.sslconf
echo "default_bits = 4096" >> ./.sslconf
echo "prompt = no" >> ./.sslconf
echo "default_md = sha256" >> ./.sslconf
echo "distinguished_name = req_distinguished_name" >> ./.sslconf
echo "x509_extensions = v3_ca" >> ./.sslconf
echo "" >> ./.sslconf
echo "[req_distinguished_name]" >> ./.sslconf
echo "C = $country" >> ./.sslconf
echo "ST = $state" >> ./.sslconf
echo "L = $loc" >> ./.sslconf
echo "O = $company" >> ./.sslconf
echo "OU = $department" >> ./.sslconf
echo "emailAddress = $email" >> ./.sslconf
echo "CN = $hostinfo" >> ./.sslconf
echo "" >> ./.sslconf
if [[ $nrsans > 0 ]]
then
    echo "[v3_ca]" >> ./.sslconf
    echo "basicConstraints = CA:FALSE" >> ./.sslconf
    echo "keyUsage = digitalSignature, keyEncipherment" >> ./.sslconf
    echo "subjectAltName = @alternate_names" >> ./.sslconf
    echo "" >> ./.sslconf
    echo "[alternate_names]" >> ./.sslconf
    for sanentry in "${sans[@]}"; do
        echo "DNS.$san_number = $sanentry" >> ./.sslconf
        ((san_number++))
    done
else
    sed -i '/x509_extensions = v3_ca/d' ./.sslconf
fi

openssl req -x509 -newkey rsa:4096 -sha256 -utf8 -days 365 -nodes -config ./.sslconf -keyout $keyfile -out $certfile
