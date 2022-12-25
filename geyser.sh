!#/bin/bash

geyser_latest_jar="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar"
geyser_latest_fingerprint="https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar/*fingerprint*/"

geyser_jar="geyser/Geyser-Standalone.jar"

# download fingerprint
geyser_latest_fingerprint_html="geyser/latest_geyser_fingerprint.html"
curl $geyser_latest_fingerprint --output $geyser_latest_fingerprint_html

# extract the md5 hash from the godaweful html file
geyser_latest_md5=$(awk 'sub(/.*<div class="md5sum">MD5: /,"") && sub(/<\/div><div>.*/,"")' $geyser_latest_fingerprint_html)

# check fingerprint against local
local_md5="$(md5sum $geyser_jar | cut -d ' ' -f 1)"

if [ local_md5 != geyser_latest_md5 ]; then
    now=`date +"%m_%d_%Y"`
    mv $geyser_jar geyser/Geyser-Standalone-$now.jar
    # download latest 
    curl $geyser_latest_jar --output $geyser_jar
fi

# start geyser
java -Xmx512M -Xms512M /
    -jar $geyser_jar /
    --config /geyser/config.yml
