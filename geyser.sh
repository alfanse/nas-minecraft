#!/bin/bash

geyser_latest_jar="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar"
geyser_latest_fingerprint="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar/*fingerprint*/"
geyser_jar="geyser/Geyser-Standalone.jar"
geyser_latest_fingerprint_html="geyser/latest_geyser_fingerprint.html"

# download fingerprint
curl --connect-timeout 5 $geyser_latest_fingerprint --output $geyser_latest_fingerprint_html

# extract the md5 hash from the godaweful html file
geyser_latest_md5=$(awk 'sub(/.*<div class="md5sum">MD5: /,"") && sub(/<\/div><div>.*/,"")' $geyser_latest_fingerprint_html)

# current inuse jar md5
bashV=$(bash --version)
isOsx=$("$bashV" == *"apple"*)
if [ isOsx ]; then
    local_md5=$(md5 $geyser_jar | cut -d ' ' -f 4)
else 
    local_md5=$(md5sum $geyser_jar | cut -d ' ' -f 1)
fi

echo "current md5: $local_md5, latest md5: $geyser_latest_md5"

# check fingerprint against local
if [ "$local_md5" != "$geyser_latest_md5" ]; then
    #move old jar to datestamped safety
    now=`date +"%m_%d_%Y"`
    mv $geyser_jar geyser/Geyser-Standalone-$now.jar
    echo "Moved older version to: geyser/Geyser-Standalone-$now.jar"

    # download latest 
    curl $geyser_latest_jar --output $geyser_jar
    echo "Downloaded latest geyser.jar"
else
    echo "Restarting $geyser_jar"
fi

# start geyser
java -Xmx512M -Xms512M -jar $geyser_jar --config geyser/config.yml
