#
#key path
keypath="/etc/wireguard/keys"
clientpath="/etc/wireguard/clients"
srvpubkey="`sudo cat $keypath/server_pub`"
wg0="/etc/wireguard/wg0.conf"
net="10.6.0.0"
host="wg.dippydawg.net"

echo "Please enter Config Name"
read client_config

umask 077
wg genkey | sudo tee $keypath/$client_config.priv | wg pubkey | sudo tee $keypath/$client_config.pub
wg genpsk | sudo tee $keypath/$client_config.psk

priv="`sudo cat $keypath/$client_config.priv`"
pub="`sudo cat $keypath/$client_config.pub`"
psk="`sudo cat $keypath/$client_config.psk`"


##Generate VPN_Client.conf
sudo cat > $clientpath/$client_config.conf <<EOL
[Interface]
PrivateKey = $priv
ListenPort = 51820
Address = 
DNS = 10.6.0.1

[Peer]
PublicKey = $pub
PresharedKey = $psk
AllowedIPs = 0.0.0.0/0
Endpoint = $host:51820
PersistentKeepalive = 21
EOL

cat >> $wg0 <<EOL

## Begin Peer Config for $client_config
[Peer]
PublicKey = $srvpubkey
PresharedKey = $psk
AllowedIPs = 10.2.0.3/32
## End $client_config
EOL
