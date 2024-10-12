function fwbootpd() {
case $1 in
add)
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/libexec/bootpd
        ;;
unblock)
	sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblock /usr/libexec/bootpd
	;;
*)
        echo "usage: fwbootpd add|unblock"
        ;;
esac
}

