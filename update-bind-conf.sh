#!/bin/bash
#
# Parses DHCP options from openvpn to update bind conf
# To use set as 'up' and 'down' script in your openvpn *.conf:
# up /etc/openvpn/update-bind-conf
# down /etc/openvpn/update-bind-conf
#
# Forked from [masterkorp/openvpn-update-resolv-conf](https://github.com/masterkorp/openvpn-update-resolv-conf)
# Licensed under the GNU GPL.  See /usr/share/common-licenses/GPL.
#
# Example envs set from openvpn:
#
#     foreign_option_1='dhcp-option DNS 193.43.27.132'
#     foreign_option_2='dhcp-option DNS 193.43.27.133'
#

[ "$script_type" ] || exit 0
[ "$dev" ] || exit 0

split_into_parts()
{
        part1="$1"
        part2="$2"
        part3="$3"
}

case "$script_type" in
  up)
        NMSRVRS=""
        for optionvarname in ${!foreign_option_*} ; do
                option="${!optionvarname}"
                logger -i -s -t "$0" "$option"
                split_into_parts $option
                if [ "$part1" = "dhcp-option" ] ; then
                        if [ "$part2" = "DNS" ] ; then
                                NMSRVRS="${NMSRVRS:+$NMSRVRS }$part3"
                        fi
                fi
        done
        R="forwarders {
"
        for NS in $NMSRVRS ; do
                R="${R}  $NS;
"
        done
        echo "$R};" > "/etc/bind/forwarders.conf"
        /usr/sbin/rndc reload
        ;;
  down)
        echo "forwarders { 192.168.178.2; };" > "/etc/bind/forwarders.conf"
        /usr/sbin/rndc reload
        ;;
esac
