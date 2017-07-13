#! /bin/sh
. /etc/envvars
set -e
exec 2>&1

# Start Jackett Server
/sbin/su-exec jackett /usr/bin/mono /opt/jackett/JackettConsole.exe \
    --DataFolder="/config"
#    --SSLFix=true \
#    --IgnoreSslErrors=true
#    --UseClient=httpclient
