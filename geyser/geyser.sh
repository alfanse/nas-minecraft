#!/bin/sh
# Start script for Geyser - downloads latest if its different to current.

geyser_latest_jar="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar"
geyser_latest_fingerprint="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar/*fingerprint*/"
geyser_jar="/geyser/Geyser-Standalone.jar"
geyser_latest_fingerprint_html="/geyser/data/latest_geyser_fingerprint.html"
bashV=$(sh --version)
local_md5=""

md5OfGeyserJar () {
    if [ ! -f "$geyser_jar" ]; then
        return 0
    fi

    # isOsx=$("$bashV" == *"apple"*)
    # if [ "$isOsx" ]; then
        # local_md5=$(md5 $geyser_jar | cut -d ' ' -f 4)
    # else 
        local_md5=$(md5sum $geyser_jar | cut -d ' ' -f 1)
    # fi
    return 0
}

echo "geyser.sh starting"
# download fingerprint
curl --connect-timeout 5 $geyser_latest_fingerprint --output $geyser_latest_fingerprint_html

# extract the md5 hash from the godaweful html file
geyser_latest_md5=$(awk 'sub(/.*<div class="md5sum">MD5: /,"") && sub(/<\/div><div>.*/,"")' $geyser_latest_fingerprint_html)

md5OfGeyserJar

echo "current md5: $local_md5, latest md5: $geyser_latest_md5"

# check fingerprint against local
if [ "$local_md5" != "$geyser_latest_md5" ]; then

    if [ -f "$geyser_jar" ]; then
        # move old jar to datestamped safety
        now=`date +"%m_%d_%Y"`
        mv $geyser_jar /geyser/Geyser-Standalone-$now.jar
        echo "Moved older version to: /geyser/Geyser-Standalone-$now.jar"
    fi

    # download latest 
    curl $geyser_latest_jar --output $geyser_jar
    echo "Downloaded latest to $geyser_jar"

    md5OfGeyserJar

    if [ "$local_md5" != "$geyser_latest_md5" ]; then
        echo "Fatal error - downloaded MD5 did not match expected, downloaded: $local_md5, expected: $geyser_latest_md5"
        exit -1
    fi
else
    echo "Restarting $geyser_jar"
fi

echo "geyser.sh finished, handing over to java"

set -e
# start geyser
java -Xmx512M -Xms512M -jar $geyser_jar --config /geyser/config.yml
