OpenVPN Update resolvconf
-------------------------

### Description

This is a script to update your /etc/resolv.conf with DNS settings that
come from the received push dhcp-options. Since network management is out
of OpenVPN client scope, this script adds and removes the provided from
those settings.

This script is a forked/modified version of [masterkorp/openvpn-update-resolv-conf](https://github.com/masterkorp/openvpn-update-resolv-conf).

### Usage

Install bind as a forwarding-only resolver, but replace the `forwarders` block with `include "/etc/bind/forwarders.conf";`.

Place the `update-bind-conf.sh` script in ``/etc/openvpn/update-bind-conf.sh`` or anywhere the
OpenVPN client can acess.

Add the following lines to your client configuration:
```
# This updates the resolvconf with dns settings
script-security 2
up /etc/openvpn/update-bind-conf.sh
down /etc/openvpn/update-bind-conf.sh
```

Just start your openvpn client with the command you used to do.

Alternatively, if you don't want to edit your client configuration, you can add the following options to your openvpn command:
```
--script-security 2 --up /etc/openvpn/update-bind-conf.sh --down /etc/openvpn/update-bind-conf.sh
```

### License

Licenced under GNU GPL.

### Credits

2016 - forked from [masterkorp/openvpn-update-resolv-conf](https://github.com/masterkorp/openvpn-update-resolv-conf)
