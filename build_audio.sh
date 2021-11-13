#!/bin/bash

BASEDIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

. $BASEDIR/params.conf

build_audio () {
    echo "Setting exec permissions..."
    sudo chmod -R +x $BASEDIR

    echo "Building audio files..."
    url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

    clear="The national weather service has no current alerts, watches, or warnings for "
    alert="Updated weather information for "
    severe="Severe weather alert for "

    clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
    alerturl=$( printf "%s\n" "$url$alert$county_name" | sed 's/ /%20/g' )
    severeurl=$( printf "%s\n" "$url$severe$county_name" | sed 's/ /%20/g' )

    wget -q -U Mozilla -O "/tmp/clear.wav" $clearurl
    wget -q -U Mozilla -O "/tmp/alert.wav" $alerturl
    wget -q -U Mozilla -O "/tmp/severe.wav" $severeurl

    cp $BASEDIR/SOUNDS/asn96Z.wav $BASEDIR/SOUNDS/asn96Z.wav.old
    cp $BASEDIR/SOUNDS/asn97.wav $BASEDIR/SOUNDS/asn97.wav.old
    cp $BASEDIR/SOUNDS/asn97S.wav $BASEDIR/SOUNDS/asn97S.wav.old

    echo "Compiling audio files..."
    sox $BASEDIR/SOUNDS/asn96Z-tweet.wav /tmp/clear.wav $BASEDIR/SOUNDS/asn96Z.wav
    sox $BASEDIR/SOUNDS/asn97-tweet.wav /tmp/alert.wav $BASEDIR/SOUNDS/asn97.wav
    sox $BASEDIR/SOUNDS/asn97S-tweet.wav /tmp/severe.wav $BASEDIR/SOUNDS/asn97S.wav

    echo "Done. Hopefully nothing explodes :)"
}

while true; do
    read -p "WARNING: You must FIRST configure params.conf for your location. Do you wish to continue? y/n - " yn
    case $yn in
        [Yy]* ) build_audio; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer '"'y'"' or '"'n'"'.";;
    esac
done