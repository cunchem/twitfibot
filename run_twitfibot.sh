#! /bin/sh
wlan_interface="wlan0"  # may need to be changed on some configuration
verbose=false
filename=""
usefile=false
usage() { echo "Usage: $0 [-w <interface>|-f <filename>] [-v]" 1>&2; exit 1; }

twitfi_from_file() {
    cat $1| ./run_twitfibot_engine.rb
}

twitfi_live() {
    wlan_interface=$1
    if iwconfig mon0 2>&1 | grep -q "No such device"
    then 
	echo "Starting monitoring interface on $wlan_interface"
	sudo airmon-ng start $wlan_interface
    else
	echo "Monitoring interface mon0 already started"
    fi
    
    sudo tshark -l -i mon0  -R "wlan.fc.type_subtype == 4  " -T fields -e frame.time    -e wlan.sa  -e wlan.da   -e radiotap.dbm_antsignal -e wlan_mgt.ssid -E separator=";"   | ./run_twitfibot_engine.rb
    
}

while getopts "w:f:vh" o; do
    case "${o}" in
        w)
            wlan_interface=${OPTARG}
            ;;
        v)
            verbose=true

            ;;
	f)
	    usefile=true
	    filename=${OPTARG}
	    ;;
	h)
	    usage
	    ;;
        *)
            usage
            ;;
    esac
done

if $usefile 
then 
    twitfi_from_file $filename
else
    twitfi_live $wlan_interface
fi


